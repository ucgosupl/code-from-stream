#pragma once

enum motor_cmd
{
    MOTOR_CMD_NOCMD,
    MOTOR_CMD_STOP,
    MOTOR_CMD_FORWARD,
    MOTOR_CMD_BACKWARD,
    MOTOR_CMD_LEFT,
    MOTOR_CMD_RIGHT,
};

void motor_task_init(void);

void motor_send_command(enum motor_cmd cmd);
