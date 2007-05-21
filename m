From: M.T.Reddy <mtreddy@gmail.com>
Subject: Re: Looking for comments on a Linux driver for HW accelerated Kasumi+F8+F9 algorithms.
Date: Mon, 21 May 2007 16:43:50 -0700
Message-ID: <f4843ad00705211643t4acd4d11i5d603a88b0d88a20@mail.gmail.com>
References: <f4843ad00705211630n533912d9y315cba5faa0e227d@mail.gmail.com>
Reply-To: mtreddy@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org
Return-path: <linux-crypto-bounce@nl.linux.org>
In-Reply-To: <f4843ad00705211630n533912d9y315cba5faa0e227d@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-bounce@nl.linux.org
Errors-to: linux-crypto-bounce@nl.linux.org
List-help: <mailto:ecartis@nl.linux.org?Subject=help>
List-unsubscribe: <mailto:linux-crypto-request@nl.linux.org?Subject=unsubscribe>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:linux-crypto-request@nl.linux.org?Subject=subscribe>
List-owner: <mailto:ecartis-owner@nl.linux.org>
List-post: <mailto:linux-crypto@nl.linux.org>
List-archive: <http://mail.nl.linux.org/linux-crypto/>
List-Id: linux-crypto.vger.kernel.org

On 5/21/07, M. T. Reddy <mtreddy@gmail.com> wrote:
> Please comment on the following patch for HW accelerated kasumi + f8 and f8 encryption engine.
> Regards,
> Marri
> ------------------------------------- patch ---------------------------------
> --- may03_denx/drivers/crypto/Kconfig    2007-05-03 08:39: 15.000000000 -0700
> +++ 0323_denx/drivers/crypto/Kconfig    2007-05-15 13:40:56.789633768 -0700
> @@ -37,6 +37,13 @@
>        If unsure say M. The compiled module will be
>        called padlock-aes.ko
>
> +config CRYPTO_KASUMI
> +    bool "Support for Kasumi driver"
> +    depends on 440EPX
> +    default N
> +    help
> +      Used in encrypting and decrypting data.
> +
>  config CRYPTO_DEV_PADLOCK_SHA
>      tristate "PadLock driver for SHA1 and SHA256 algorithms"
>      depends on CRYPTO_DEV_PADLOCK
> --- may03_denx/drivers/crypto/Makefile    2007-05-03 08:39:15.000000000 -0700
> +++ 0323_denx/drivers/crypto/Makefile    2007-04-25 13:39:52.000000000 -0700
> @@ -2,3 +2,4 @@
>   obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
>  obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
>  obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
> +obj-$(CONFIG_KASUMI_CRYPTO) +=kasumi.o
> --- may03_denx/drivers/crypto/kasumi.h    1969-12-31 16:00: 00.000000000 -0800
> +++ 0323_denx/drivers/crypto/kasumi.h    2007-05-15 15:16:27.046502312 -0700
> @@ -0,0 +1,122 @@
> +/**********************************************************************
> + *
> + * kasumi.h
>  + * Cryptographic Driver APIs.
> + *
> + * Support for Kasumi F8 and F9 hardware crypto engine.
> + * author: tmarri@amcc.com
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + *
> + *
> + * DISCLAIMER
> + *
> + * This software is provided 'as is' with no explicit or implied warranties
> + * in respect of its properties, including, but not limited to, correctness
> + * and/or fitness for purpose.
> + * ---------------------------------------------------------------------------
> + */
> +#define    MULTIPLE_DATA_ENC 1
> +
> +#define KASUMI_TEST    0
> +
> +/* Dynamic major number */
> +#define KASUMI_MAJOR    0
> +
> +/* IOCTL numbers */
> +#define KASUMI_IOCTL_ENCRYPT    0x100
> +#define KASUMI_IOCTL_DECRYPT    0x101
> +#define KASUMI_IOCTL_F8_MODE    0x102
> +#define KASUMI_IOCTL_F9_MODE    0x103
> +
> +#define SDR0_SRST1        0x201
> +#define DCR_PLB4A0        0x81
> +#define DCR_UIC0_SR    0xC0
> +#define DCR_UIC0_ER    0xC2
> +
> +/* Need to disable READ pipeline to avoid hang on PLB bus */
> +#define DISABLE_RD_PIPE_LINE    0xf9ffffff
> +#define KASUMI_RESET_MSK        0x00002000
> +#define KASU0_BASE                0x0E0180000ULL
>  +
> +#define KASU0_DATA_IN0        0x0
> +#define KASU0_DATA_OUT0    0x0
> +#define KASU0_DATA_IN1        0x4
> +#define KASU0_DATA_OUT1    0x4
> +#define KASU0_CTRL            0x8
> +#define KASU0_STATUS        0x8
> +#define KASU0_MODE        0xc
> +#define KASU0_KEY0        0x10
> +#define KASU0_KEY1        0x14
> +#define KASU0_KEY2        0x18
> +#define KASU0_KEY3        0x1c
> +#define KASU0_COUNT    0x20
> +#define KASU0_CONFIG    0x24
> +#define KASU0_FRESH    0x28
> +
> +#define KASUMI_DEC_MODE    0x02000000
> +#define KASUMI_ENC_MODE    0x03000000
> +#define KASUMI_F8_ENC_MODE    0x05000000
> +#define KASUMI_F8_DEC_MODE    0x04000000
> +#define KASUMI_F9_ENC_MODE    0x09000000
> +#define KASUMI_F9_DEC_MODE    0x08000000
> +
> +#define KASUMI_DATA_READY    0x01000000
> +
> +#define KASUMI_VAL_KEYS    0x04000000
> +#define KASUMI_VAL_MODE    0x02000000
> +#define KASUMI_VAL_DATA    0x08000000
> +#define KASUMI_VAL_CFG        0x10000000
> +#define KASUMI_VAL_COUNT    0x20000000
> +#define KASUMI_VAL_FRESH    0x40000000
> +
> +#define kasumi_byte_swap(x)        ((((uint)x & 0xff000000) >> 24) | \
> +                                (((uint)x & 0x00ff0000) >> 8) | \
> +                                (((uint)x & 0x0000ff00) << 8) | \
> +                                (((uint)x & 0x000000ff) << 24))
> +
> +struct kasumi_desc {
> +    uint mode;
> +    uint count;
> +    uint config;
> +    uint fresh;
> +    uint key0;
> +    uint key1;
> +    uint key2;
> +    uint key3;
> +    uint *data_in;
> +    uint *data_out;
> +};
> +struct kasumi_regs{
> +    uint    *ctrl;
> +    uint    *status;
> +    uint    *mode;
> +    uint    *key0;
> +    uint    *key1;
> +    uint    *key2;
> +    uint    *key3;
> +    uint    *data_in0;
> +    uint    *data_in1;
> +    uint    *data_out0;
> +    uint    *data_out1;
> +    uint    *count;
> +    uint    *config;
> +    uint    *fresh;
> +};
> +
> +struct kasumi_f8_f9_desc {
> +    struct kasumi_desc kd;
> +    uint len;
> +    uint bearer;
> +    uint direction;
> +};
> +int kasumi_f9_encrypt(struct kasumi_desc *test, uint len, uint direction);
> +int kasumi_f8_encrypt(struct kasumi_desc *test, uint len, uint bearer,
> +              uint direction);
> +int kasumi_decrypt(struct kasumi_desc *test);
> +int kasumi_encrypt(struct kasumi_desc *test);
> --- may03_denx/drivers/crypto/kasumi.c    1969-12-31 16:00:00.000000000 -0800
> +++ 0323_denx/drivers/crypto/kasumi.c    2007-05-15 15:16: 27.045502464 -0700
> @@ -0,0 +1,898 @@
> +/*
> + * Cryptographic Driver APIs.
> + *
> + * Support for Kasumi F8 and F9 hardware crypto engine.
> + * author: tmarri@amcc.com
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + *
> + *
> + * DISCLAIMER
> + *
> + * This software is provided 'as is' with no explicit or implied warranties
> + * in respect of its properties, including, but not limited to, correctness
> + * and/or fitness for purpose.
> + * ---------------------------------------------------------------------------
> + */
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <asm/io.h>
> +#include <linux/fcntl.h>
> +#include <linux/cdev.h>
> +#include <linux/seq_file.h>
> +#include <linux/fs.h>        /* everything... */
> +
> +#include <asm/system.h>
> +#include <asm/uaccess.h>    /* copy_*_user */
> +
> +#include <asm/ibm44x.h>
> +#include "kasumi.h "
> +
> +static int kasumi_major = KASUMI_MAJOR;
> +static uint data_in[512], data_out[512];
> +static uint *kasumi_base;
> +static struct kasumi_regs kreg;
> +
> +#ifdef KASUMI_TEST
> +/*
> +** Function to test KASUMI encrypt and decrypt modes
> +*/
> +static int kasumi_test(void)
> +{
> +    struct kasumi_desc test_in, test_out;
> +    uint data_in0[2], data_in1[2], data_out0[2], data_out1[2];
> +
> +    test_in.key0 = 0x9F45D62B;
> +    test_in.key1 = 0x00B3C582;
> +    test_in.key2 = 0x10492C95;
> +    test_in.key3 = 0x48FF8148;
> +    data_in0[0] = 0xEA024714;
> +    data_in0[1] = 0xAD5C4D84;
> +    test_in.data_in = &data_in0[0];
> +    test_in.data_out = &data_out0[0];
> +
> +    printk(KERN_INFO "Encryption test\n");
> +    kasumi_encrypt(&test_in);
> +
> +    test_out.key0 = 0x9F45D62B;
> +    test_out.key1 = 0x00B3C582;
> +    test_out.key2 = 0x10492C95;
> +    test_out.key3 = 0x48FF8148;
> +    test_out.data_in = &data_in1[0];
> +    test_out.data_out = &data_out1[0];
> +    test_out.data_in[0] = data_out0[0];
> +    test_out.data_in[1] = data_out0[1];
> +
> +    printk(KERN_INFO "Decryption test\n");
> +    kasumi_decrypt(&test_out);
> +    printk(KERN_INFO "data_out0[0]=0x%x\n", data_out0[0]);
> +    printk(KERN_INFO "data_out0[1]=0x%x\n", data_out0[1]);
> +    printk(KERN_INFO "data_out1[0]=0x%x\n", data_out1[0]);
> +    printk(KERN_INFO "data_out1[1]=0x%x\n", data_out1[1]);
> +
> +    if (data_in0[0] == data_out1[0])
> +        printk(KERN_INFO " Data 0 matched\n");
> +    else
> +        printk(KERN_INFO " Data 0 NOT matched\n");
> +    if (data_in0[1] == data_out1[1])
> +        printk(KERN_INFO " Data 1 matched\n");
> +    else
> +        printk(KERN_INFO " Data 1 NOT matched\n");
> +    return 0;
> +}
> +
> +/*
> +** Function to test F* mode of encryption
> +*/
> +static void kasumi_test_f8_1(void)
> +{
> +    int len = 0x31E, bearer = 0xc, direction = 1;
> +    struct kasumi_desc test_in;
> +    struct kasumi_desc test_out;
> +    int i = 0;
> +    uint data_in[32] = {
> +        0x7EC61272, 0x743BF161, 0x4726446A, 0x6C38CED1,
> +        0x66F6CA76, 0xEB543004, 0x4286346C, 0xEF130F92,
> +        0x922B0345, 0x0D3A9975, 0xE5BD2EA0, 0xEB55AD8E,
> +        0x1B199E3E, 0xC4316020, 0xE9A1B285, 0xE7627953,
> +        0x59B7BDFD, 0x39BEF4B2, 0x484583D5, 0xAFE082AE,
> +        0xE638BF5F, 0xD5A60619, 0x3901A08F, 0x4AB41AAB, 0x9B134880
> +    };
> +    uint data_cmp[32] = {
> +        0xD1E2DE70, 0xEEF86C69, 0x64FB542B, 0xC2D460AA,
> +        0xBFAA10A4, 0xA093262B, 0x7D199E70, 0x6FC2D489,
> +        0x15532969, 0x10F3A973, 0x012682E4, 0x1C4E2B02,
> +        0xBE2017B7, 0x253BBF93, 0x09DE5819, 0xCB42E819,
> +        0x56F4C99B, 0xC9765CAF, 0x53B1D0BB, 0x8279826A,
> +        0xDBBC5522, 0xE915C120, 0xA618A5A7, 0xF5E89708, 0x9339650F
> +    };
> +    uint data_out0[32];
> +    uint data_out1[32];
> +
> +    test_in.key0 = 0x2BD6459F;
> +    test_in.key1 = 0x82C5B300;
> +    test_in.key2 = 0x952C4910;
> +    test_in.key3 = 0x4881FF48;
> +
> +    test_in.count = 0x72A4F20F;
> +
> +    printk(KERN_INFO "in CFG=0x%x\n", test_in.config);
> +    test_in.data_in = &data_in[0];
> +    test_in.data_out = &data_out0[0];
> +    kasumi_f8_encrypt(&test_in, len, bearer, direction);
> +
> +    i = 0;
> +    for (i = 0; i < 32; i++) {
> +        if (data_out0[i] != data_cmp[i])
> +            printk(KERN_INFO
> +                   "data MISS match data recieved=0x%x expected =0x%x\n\nn",
> +                   data_out0[i], data_cmp[i]);
> +        else
> +            printk(KERN_INFO "data MATCHED\n");
> +
> +    }
> +}
> +
> +/*
> +** Function to test F9 mode of encryption
> +*/
> +static void kasumi_test_f9(void)
> +{
> +    struct kasumi_desc test_in;
> +    int i = 0;
> +    uint direction = 0, len = 189;
> +    uint data_in[6] = {
> +        0x6B227737,
> +        0x296F393C,
> +        0x8079353E,
> +        0xDC87E2E8,
> +        0x05D2EC49,
> +        0xA4F2D8E0
> +    };
> +    uint data_out[2];
> +
> +    test_in.key0 = 0x2BD6459F;
> +    test_in.key1 = 0x82C5B300;
> +    test_in.key2 = 0x952C4910;
> +    test_in.key3 = 0x4881FF48;
> +    test_in.fresh = 0x05D2EC49;
> +    test_in.count = 0x38A6F056;
> +
> +    for (i = 0; i < 6; i++)
> +        data_in[i] = kasumi_byte_swap(data_in[i]);
> +    test_in.data_in = &data_in[0];
> +    test_in.data_out = &data_out[0];
> +    kasumi_f9_encrypt(&test_in, len, direction);
> +    if (data_out[0] == 0xf63bd72c)
> +        printk(KERN_INFO
> +               " F9 test passed Expected data = 0x%x data recieved=0x%x\n",
> +               0xf63bd72c, data_out[0]);
> +    else
> +        printk(KERN_INFO
> +               " \n F9 test Failed Expected data = 0x%x data recieved=0x%x\n",
> +               0xf63bd72c, data_out[0]);
> +
> +}
> +#endif
> +
> +/*
> +**FUNCTION:kasumi_encrypt_decrypt()
> +** args: kd is kasumi descriptor which holds all the requred data to do kasumi
> +** mode encryption and decryption
> +** Description:  This function follows the kasumi algorithm to encrypt and decrypt.
> +**  1. Check for interrupt bit KDA(Kasumi Data Availability)
> +**  2. check for data availability bit in CTRL register and write 1 to clear it
> +**  3. Set keys
> +**  4. set mode
> +**  5. set inputdata
> +**  6. validate keys , mode and data
> +**  7. wait for the data availability and then read the data.
> +**   This function can only do 64bit data encryption at given time
> +**   Please check the test() in the comment section.
> +*/
> +static int kasumi_encrypt_decrypt(struct kasumi_desc *kd)
> +{
> +    uint time_out = 100;
> +
> +    /*
> +     * CTRL_STATUS[0] to reset the DATA out mechanism
> +     */
> +    printk(KERN_WARNING "kreg.ctrl 0x%x\n", kreg.ctrl);
> +    out_be32(kreg.ctrl, in_be32(kreg.ctrl) | KASUMI_DATA_READY);
> +    /*
> +     * Check for interrupt bit for data availability bit set .
> +     * if set clear it
> +     */
> +    if (mfdcr(DCR_UIC0_SR) & 0x08000000) {
> +        mtdcr(DCR_UIC0_SR, (mfdcr(DCR_UIC0_SR) & ~0x08000000));
> +    }
> +
> +    /*
> +     * Check if KASUMI is ready  for data input
> +     */
> +    if (!mfdcr(DCR_UIC0_SR) & 0x10000000)
> +        printk(KERN_INFO "KASUMI is ready for data\n");
> +
> +    /*
> +     * need keys
> +     */
> +    out_be32(kreg.key0, kd->key0);
> +    out_be32(kreg.key1, kd->key1);
> +    out_be32(kreg.key2, kd->key2);
> +    out_be32(kreg.key3, kd->key3);
> +    /*
> +     * Check for correct  mode
> +     */
> +    if ((kd->mode != KASUMI_ENC_MODE) && (kd->mode != KASUMI_DEC_MODE)) {
> +        printk(KERN_INFO "KASUMI ERROR: invalid mode\n\n");
> +        return -1;
> +    }
> +
> +    /*
> +     * set mode
> +     */
> +    out_be32(kreg.mode, kd->mode);
> +    /*
> +     * write data
> +     */
> +    if ((kd->data_in != NULL) && (kd->data_in)) {
> +        out_be32(kreg.data_in0 , kd->data_in[0]);
> +        out_be32(kreg.data_in1, kd->data_in[1]);
> +    } else {
> +        printk(KERN_INFO "No data passed\n");
> +        return -1;
> +    }
> +
> +    /*
> +     * validate data CTRL_STAT[4]
> +     * Validate mode CTRL_STA[1] = 1
> +     * vlaidatkeys keys CTRL_STAT[2] = 1
> +     */
> +    out_be32(kreg.ctrl, in_be32(kreg.ctrl) | (KASUMI_VAL_DATA |
> +                          KASUMI_VAL_KEYS |
> +                          KASUMI_VAL_MODE));
> +    /*
> +     * Just in case DATA validation not finished
> +     */
> +    time_out = 100;
> +    while (in_be32(kreg.ctrl) & KASUMI_VAL_DATA) {
> +        time_out--;
> +        mdelay(1);
> +        if (time_out <= 0) {
> +            printk(KERN_INFO
> +                   "ERROR: at line %d Timed out KASU0_CTRL=0x%x\n",
> +                   __LINE__, in_be32(kreg.ctrl));
> +            break;
> +        }
> +    }
> +
> +    /*
> +     * Check if data available bit is set
> +     */
> +    if (!mfdcr(DCR_UIC0_SR) & 0x08000000)
> +        printk(KERN_WARNING
> +               "KASUMI data NOT available and  NO KDA interrupt occured\n");
> +
> +    /*
> +     * Is data avaialbel
> +     */
> +    time_out = 100;
> +    while (!(in_be32(kreg.status) & KASUMI_DATA_READY)) {
> +        time_out--;
> +        mdelay(1);
> +        if (time_out <= 0) {
> +            printk(KERN_INFO "line %d Timed out KASU0_CTRL=0x%x\n",
> +                   __LINE__, in_be32(kreg.ctrl));
> +            break;
> +        }
> +    }
> +
> +    if (!(in_be32(kreg.status ) & KASUMI_DATA_READY))
> +        printk(KERN_WARNING "Data is not ready\n");
> +
> +    kd->data_out[0] = in_be32(kreg.data_out0);
> +    kd->data_out[1] = in_be32(kreg.data_out1);
> +    return 0;
> +}
> +
> +/*
> +** Kasumi encryption function calls the kasumi_encrypt_decrypt()
> +**
> +*/
> +int kasumi_encrypt(struct kasumi_desc *test)
> +{
> +    test->mode = KASUMI_ENC_MODE;
> +    if (kasumi_encrypt_decrypt(test) != 0) {
> +        printk(KERN_INFO "kasumi_encrypt_decrypt returned error");
> +        return -1;
> +    } else
> +        return 0;
> +
> +}
> +
> +/*
> +** Kasumi encryption function calls the kasumi_encrypt_decrypt()
> +**
> +*/
> +int kasumi_decrypt(struct kasumi_desc *test)
> +{
> +    test->mode = KASUMI_DEC_MODE;
> +    if (kasumi_encrypt_decrypt(test) != 0) {
> +        printk(KERN_INFO "kasumi_encrypt_decrypt returned error");
> +        return -1;
> +    } else
> +        return 0;
> +
> +}
> +
> +/*
> +**
> +**FUNCTION:kasumi_encrypt_decrypt()
> +**args: kd is kasumi descriptor which holds all the requred data to do kasumi mode encryption and decryption
> +**Description:  This function follows the kasumi algorithm to encrypt and decrypt.
> +**  1. Check for interrupt bit KDA(Kasumi Data Availability)
> +**  2. check for data availability bit in CTRL register and write 1 to clear it
> +**  3. Set keys
> +**  4. set mode
> +**  5. set config
> +**  6. set count
> +**  7. set inputdata
> +**  8. validate keys , mode , config , count and data
> +**  9. wait for the data availability and then read the data.
> +**   This function can encrypt block data
> +**   Please check the test_f8_1() in the comment section.
> +*/
> +static int kasumi_f8_encrypt_decrypt(struct kasumi_desc *kd)
> +{
> +    int time_out = 10000;
> +    int len = 0;
> +    int i = 0;
> +
> +    len = ((kd->config & 0xff) << 8) | ((kd->config & 0xff00) >> 8);
> +    /*Reset data out mechanism */
> +    /*CTRL_STATUS[0] to reset the DATA out mechanism */
> +    out_be32(kreg.ctrl, in_be32(kreg.ctrl) | KASUMI_DATA_READY);
> +
> +    if (mfdcr(DCR_UIC0_SR) & 0x08000000)
> +        mtdcr(DCR_UIC0_SR, (mfdcr(DCR_UIC0_SR) & ~0x08000000));
> +
> +    if (!mfdcr(DCR_UIC0_SR) & 0x10000000)
> +        printk(KERN_INFO "KASUMI is NOT ready for data\n");
> +
> +    /*need keys */
> +
> +    out_be32(kreg.key0, kd->key0);
> +    out_be32(kreg.key1, kd->key1);
> +    out_be32(kreg.key2, kd->key2);
> +    out_be32(kreg.key3, kd->key3);
> +    /*write config */
> +    out_be32(kreg.config, kd->config);
> +    /* Write count */
> +    out_be32(kreg.count, kd->count);
> +    /*set mode */
> +    if (kd->mode != KASUMI_F8_ENC_MODE) {
> +        printk(KERN_INFO "KASUMI Invalid mode\n");
> +        return -1;
> +    }
> +
> +    out_be32(kreg.mode, kd->mode);
> +
> +    /*
> +     * write data
> +     * validate data CTRL_STAT[4]
> +     * Validate mode CTRL_STA[1] = 1
> +     * vlaidatkeys keys CTRL_STAT[2] = 1
> +     * vlaidatkeys count and config
> +     */
> +    out_be32(kreg.ctrl, in_be32(kreg.ctrl) | (KASUMI_VAL_CFG |
> +                          KASUMI_VAL_COUNT |
> +                          KASUMI_VAL_KEYS |
> +                          KASUMI_VAL_MODE));
> +    time_out = 100;
> +    /*
> +     ** Just in case DATA validation is not finished
> +     */
> +    while (in_be32( kreg.ctrl) & (KASUMI_VAL_CFG | KASUMI_VAL_COUNT |
> +                     KASUMI_VAL_KEYS | KASUMI_VAL_MODE)) {
> +        time_out--;
> +        mdelay(1);
> +        if (time_out <= 0) {
> +            printk(KERN_INFO
> +                   " KASUMI:line %d Timed out KASU0_CTRL=0x%x\n",
> +                   __LINE__, in_be32(kreg.ctrl));
> +            break;
> +        }
> +
> +    }
> +
> +    if (in_be32(kreg.ctrl )
> +        & (KASUMI_VAL_CFG | KASUMI_VAL_COUNT |
> +           KASUMI_VAL_KEYS | KASUMI_VAL_MODE))
> +        printk(KERN_WARNING
> +               " CFG COUNT KEYS MODE validation NOT complete\n");
>  +    /*
> +     ** Here we encode 64bits a time till whole block is encrypted
> +     */
> +    while (len > 0) {
> +        if ((&kd->data_in[i] != NULL) && (&kd->data_in[i + 1] != NULL)) {
>  +            out_be32(kreg.data_in0, kd->data_in[i]);
> +            out_be32(kreg.data_in1, kd->data_in[i + 1]);
> +        } else {
> +            printk(KERN_INFO "No data passed\n");
> +            break;
> +        }
> +
> +        out_be32(kreg.ctrl, in_be32(kreg.ctrl) | KASUMI_VAL_DATA);
> +        time_out = 100;
> +        while (in_be32(kreg.ctrl) & (KASUMI_VAL_DATA)) {
> +            time_out--;
> +            if (time_out <= 0) {
> +                printk(KERN_INFO
> +                       "KASUMI: line %d Timed out KASU0_CTRL=0x%x\n",
> +                       __LINE__, in_be32(kreg.ctrl));
> +                break;
> +            }
> +        }
> +
> +        if (in_be32(kreg.ctrl) & (KASUMI_VAL_DATA))
> +            printk(KERN_WARNING "Data validation NOT complete\n");
> +
> +        time_out = 100;
> +        while (!(in_be32( kreg.status) & KASUMI_DATA_READY)) {
> +            mdelay(1);
> +            time_out--;
> +            if (time_out <= 0) {
> +                printk(KERN_INFO
> +                       "line %d Timed out KASU0_CTRL=0x%x\n",
> +                       __LINE__, in_be32(kreg.ctrl));
> +                break;
> +            }
> +
> +        }
> +
> +        if (!(in_be32(kreg.status) & KASUMI_DATA_READY)) {
> +            printk(KERN_WARNING "Data is not ready\n");
> +            break;
> +        }
> +
> +        kd->data_out[i] = kasumi_byte_swap(in_be32(kreg.data_out0));
> +        kd->data_out[i + 1] = kasumi_byte_swap(in_be32(kreg.data_out1));
> +        /*
> +         ** CTRL_STATUS[0] to reset the DATA out mechanism
> +         */
> +        out_be32(kreg.ctrl, KASUMI_DATA_READY);
> +        if (!mfdcr(DCR_UIC0_SR) & 0x10000000)
> +            printk(KERN_WARNING "KASUMI is NOT ready for data\n");
> +
> +        i += 2;
> +        len = len - 64;
> +    }
> +
> +    return 0;
> +}
> +
> +/*
> +** arg1: hte filled kasumi_desc structure pointer
> +** arg2:  len
> +** arg3:  bearer
> +** arg4:  direction
> +*/
> +int kasumi_f8_encrypt(struct kasumi_desc *test, uint len, uint bearer,
> +              uint direction)
> +{
> +    int i = 0;
> +
> +    test->config = (len << 16 | bearer << 1 | direction);
> +    test->mode = KASUMI_F8_ENC_MODE;
> +    test->key0 = kasumi_byte_swap(test->key0);
> +    test->key1 = kasumi_byte_swap(test->key1);
> +    test->key2 = kasumi_byte_swap(test->key2);
> +    test->key3 = kasumi_byte_swap(test->key3);
> +    test->count = kasumi_byte_swap(test->count);
> +    test->config = kasumi_byte_swap(test->config);
> +    len = len / (32);
> +
> +    for (i = 0; i <= len; i++)
> +        test->data_in[i] = kasumi_byte_swap(test->data_in[i]);
> +
> +    if (kasumi_f8_encrypt_decrypt(test) != 0) {
> +        printk(KERN_INFO
> +               "kasumi_f8_encrypt_decrypt() returned error\n");
> +        return -1;
> +    }
> +
> +    return 0;
> +}
> +
> +/*
> +**
> +**FUNCTION:kasumi_encrypt_decrypt()
> +**args: kd is kasumi descriptor which holds all the requred data to do kasumi mode encryption and decryption
> +**Description:  This function follows the kasumi algorithm to encrypt and decrypt.
> +**  1. Check for interrupt bit KDA(Kasumi Data Availability)
> +**  2. check for data availability bit in CTRL register and write 1 to clear it
> +**  3. Set keys
> +**  4. set mode
> +**  5. set config
> +**  6. set count
> +**  7. set inputdata
> +**  8. validate keys , mode , config , count and data
> +**  9. wait for the data availability and then read the data.
> +**   This function can encrypt block data
> +**   Please check the test_f9_1() in the comment section.
> +*/
> +int kasumi_f9(struct kasumi_desc *kd)
> +{
> +    int time_out = 10000;
> +    int len = 0;
> +    int i = 0;
> +
> +    /*
> +     ** Get the lenght of the block we are going to encode
> +     */
> +    len = ((kd->config & 0xff) << 8) | ((kd->config & 0xff00) >> 8);
> +
> +    /*
> +     ** CTRL_STATUS[0] to reset the DATA out mechanism
> +     */
> +    out_be32(kreg.ctrl, in_be32(kreg.ctrl) | KASUMI_DATA_READY);
> +    if (mfdcr(DCR_UIC0_SR) & 0x08000000)
> +        mtdcr(DCR_UIC0_SR, (mfdcr(DCR_UIC0_SR) & ~0x08000000));
> +
> +    if (!(mfdcr(DCR_UIC0_SR) & 0x10000000))
> +        printk(KERN_INFO "KASUMI is ready for data\n");
> +
> +    /*
> +     ** need keys
> +     */
> +    out_be32(kreg.key0, kd->key0);
>  +    out_be32(kreg.key1, kd->key1);
> +    out_be32(kreg.key2, kd->key2);
> +    out_be32(kreg.key3, kd->key3);
> +    /*
> +     ** write config
> +     */
> +    out_be32(kreg.config, kd->config);
> +    /*
> +     ** Write count
> +     */
> +    out_be32(kreg.count, kd->count);
> +    /*
> +     ** set fresh
> +     */
> +    out_be32(kreg.fresh, kd->fresh);
> +    /*
> +     ** set mode
> +     */
> +    if (kd->mode != KASUMI_F9_ENC_MODE) {
> +        printk(KERN_INFO "KASUMI Invalid mode\n");
> +        return -1;
> +    }
> +
> +    out_be32(kreg.mode, kd->mode);
> +    /*
> +     * write data
> +     * validate data CTRL_STAT[4]
> +     * Validate mode CTRL_STA[1] = 1
> +     * vlaidatkeys keys CTRL_STAT[2] = 1
> +     * vlaidatkeys count and config
> +     */
> +    out_be32(kreg.ctrl,
> +         in_be32(kreg.ctrl) |
> +         (KASUMI_VAL_CFG | KASUMI_VAL_COUNT | KASUMI_VAL_KEYS |
> +          KASUMI_VAL_MODE | KASUMI_VAL_FRESH));
> +    time_out = 100;
> +    /*
> +     ** Just in case validation is not complete.
> +     */
> +    while (in_be32(kreg.ctrl) & (KASUMI_VAL_CFG |
> +                     KASUMI_VAL_COUNT | KASUMI_VAL_KEYS
> +                     | KASUMI_VAL_MODE | KASUMI_VAL_FRESH)) {
> +        time_out--;
> +        mdelay(1);
> +        if (time_out <= 0) {
> +            printk(KERN_INFO "line %d Timed out KASU0_CTRL=0x%x\n",
> +                   __LINE__, in_be32(kreg.ctrl));
> +            break;
> +        }
> +    }
> +
> +    if (in_be32(kreg.ctrl) & (KASUMI_VAL_CFG |
> +                  KASUMI_VAL_COUNT | KASUMI_VAL_KEYS
>  +                  | KASUMI_VAL_MODE | KASUMI_VAL_FRESH))
> +        printk(KERN_WARNING
> +               " CFG COUNT KEYS MODE validation NOT complete\n");
> +
> +    /*
> +     **  Loop around this code till we encode all 64bit data blocks
> +     */
> +    while (len > 0) {
> +
> +        if ((&kd->data_in[i] != NULL) && (&kd->data_in[i + 1] != NULL)) {
> +            out_be32(kreg.data_in0, kd->data_in[i]);
> +            out_be32( kreg.data_in1, kd->data_in[i + 1]);
> +        } else {
> +            printk(KERN_INFO "No data passed\n");
> +            return -1;
> +        }
> +
> +        out_be32(kreg.ctrl, in_be32(kreg.ctrl) | KASUMI_VAL_DATA);
> +        time_out = 100;
> +
> +        while (in_be32(kreg.ctrl) & (KASUMI_VAL_DATA)) {
> +            time_out--;
> +            mdelay(1);
> +            if (time_out <= 0) {
> +                printk(KERN_INFO
> +                       "line %d Timed out KASU0_CTRL=0x%x\n",
> +                       __LINE__, in_be32(kreg.ctrl));
> +                break;
> +            }
> +        }
> +
> +        if (in_be32( kreg.ctrl) & (KASUMI_VAL_DATA)) {
> +            printk(KERN_INFO "Data validation NOT complete\n");
> +        }
> +
> +        if (!(mfdcr(DCR_UIC0_SR) & 0x10000000))
> +            printk(KERN_INFO "KASUMI is NOT ready for data\n");
> +
> +        i += 2;
> +        len = len - 64;
> +    }
> +
> +    if (!(mfdcr(DCR_UIC0_SR) & 0x08000000))
> +        printk(KERN_INFO
> +               "KASUMI data NOT available and  NO KDA interrupt occured\n");
> +
> +    /*
> +     ** Is data avaialbel
> +     */
> +    time_out = 100;
> +    while (!(in_be32(kreg.status) & KASUMI_DATA_READY)) {
> +        time_out--;
> +        mdelay(1);
> +        if (time_out <= 0) {
> +            printk(KERN_INFO "line %d Timed out KASU0_CTRL=0x%x\n",
> +                   __LINE__, in_be32(kreg.ctrl));
> +        }
> +
> +    }
> +
> +    if (!(in_be32(kreg.status) & KASUMI_DATA_READY))
> +        printk(KERN_WARNING "Data is not ready\n");
> +    kd->data_out[0] = kasumi_byte_swap(in_be32(kreg.data_out0));
> +    kd->data_out[1] = kasumi_byte_swap(in_be32(kreg.data_out1));
> +    out_be32( kreg.ctrl, KASUMI_DATA_READY);
> +    return 0;
> +}
> +
> +/*
> +** arg1: kasumi_desc structure
> +**  arg2: len
> +**  arg3: direction
> +*/
> +int kasumi_f9_encrypt(struct kasumi_desc *test, uint len, uint direction)
> +{
> +    test->config = (len << 16 | direction);
> +    test->config = (0x00BD0000);
> +    test->mode = KASUMI_F9_ENC_MODE;
> +    test->key0 = kasumi_byte_swap(test->key0);
> +    test->key1 = kasumi_byte_swap(test->key1);
> +    test->key2 = kasumi_byte_swap(test->key2);
> +    test->key3 = kasumi_byte_swap(test->key3);
> +    test->count = kasumi_byte_swap(test->count);
> +    test->config = kasumi_byte_swap(test->config);
> +    test->fresh = kasumi_byte_swap(test->fresh);
> +
> +    if (kasumi_f9(test) != 0) {
> +        printk(KERN_INFO
> +               "kasumi_f8_encrypt_decrypt() returned error\n");
> +        return -1;
> +    }
> +
> +    return 0;
> +}
> +
> +/*
> +**IOCTL function to let this driver usaed from user space.
> +**
> +*/
> +static int kasumi_ioctl(struct inode *inode, struct file *filep,
> +            unsigned int cmd, unsigned long arg)
> +{
> +    int kerr = 0;
> +    struct kasumi_f8_f9_desc kd_f89;
> +
> +    kd_f89.kd.data_in = &data_in[0];
> +    kd_f89.kd.data_out = &data_out[0];
> +
> +    switch (cmd) {
> +    case KASUMI_IOCTL_ENCRYPT:
> +        {
> +            copy_from_user(&kd_f89,
> +                       (struct kasumi_f8_f9_desc __user *)arg,
> +                       sizeof(struct kasumi_f8_f9_desc));
> +            kerr = kasumi_encrypt(&kd_f89.kd);
> +            copy_to_user(&kd_f89,
> +                     (struct kasumi_f8_f9_desc __user *)arg,
> +                     sizeof(struct kasumi_f8_f9_desc));
> +
> +            if (kerr < 0)
> +                return kerr;
> +            return 0;
> +            break;
> +        }
> +    case KASUMI_IOCTL_DECRYPT:
> +        {
> +            printk(KERN_INFO "kd_f89.kd.data_in[0]=0x%x\n",
> +                   kd_f89.kd.data_in[0]);
> +            printk(KERN_INFO "kd_f89.kd.data_in[1]=0x%x\n",
> +                   kd_f89.kd.data_in[1]);
> +            copy_from_user(&kd_f89,
> +                       (struct kasumi_f8_f9_desc __user *)arg,
> +                       sizeof(struct kasumi_f8_f9_desc));
> +            kerr = kasumi_decrypt(&kd_f89.kd);
> +            copy_to_user(&kd_f89,
> +                     (struct kasumi_f8_f9_desc __user *)arg,
> +                     sizeof(struct kasumi_f8_f9_desc));
> +            if (kerr < 0)
> +                return kerr;
> +            break;
> +        }
> +    case KASUMI_IOCTL_F8_MODE:
> +        {
> +            copy_from_user(&kd_f89,
> +                       (struct kasumi_f8_f9_desc __user *)arg,
> +                       sizeof(struct kasumi_f8_f9_desc));
> +            kerr =
> +                kasumi_f8_encrypt(&kd_f89.kd, kd_f89.len,
>  +                          kd_f89.bearer, kd_f89.direction);
> +            copy_to_user(&kd_f89,
> +                     (struct kasumi_f8_f9_desc __user *)arg,
> +                     sizeof(struct kasumi_f8_f9_desc));
> +            if (kerr < 0)
> +                return kerr;
> +            break;
> +        }
> +    case KASUMI_IOCTL_F9_MODE:
> +        {
> +            copy_from_user(&kd_f89,
> +                       (struct kasumi_f8_f9_desc __user *)arg,
> +                       sizeof(struct kasumi_f8_f9_desc));
> +            kerr =
> +                kasumi_f9_encrypt(&kd_f89.kd, kd_f89.len,
> +                          kd_f89.direction);
> +            copy_to_user(&kd_f89,
> +                     (struct kasumi_f8_f9_desc __user *)arg,
> +                     sizeof(struct kasumi_f8_f9_desc));
> +            if (kerr < 0)
> +                return kerr;
> +            break;
> +        }
> +    default:
> +        return -ENOTTY;
> +    }
> +
> +    return 0;
> +}
> +
> +/*
> +** file operations
> +*/
> +struct file_operations kasumi_fops = {
> +    .ioctl = kasumi_ioctl,
> +};
> +
> +/*
>  +** Moudle initialization
> +**/
> +int kasumi_init_module(void)
> +{
> +    int kerr = 0;
> +    dev_t dev = MKDEV(kasumi_major, 0);
> +    struct cdev *k_cdev = cdev_alloc();
> +
> +    printk(KERN_INFO "Loading Kasumi Driver\n");
> +    if (kasumi_major)
> +        kerr = register_chrdev_region(dev, 1, "kasumi");
> +    else {
> +        kerr = alloc_chrdev_region(&dev, 0, 1, "kasumi");
> +        kasumi_major = MAJOR(dev);
> +    }
> +
> +    if (kerr < 0) {
> +        printk(KERN_ERR "KASUMI:Failed to get major number");
> +        return kerr;
> +    }
> +
> +    cdev_init(k_cdev, &kasumi_fops);
> +    k_cdev->owner = THIS_MODULE;
> +    k_cdev->ops = &kasumi_fops;
> +    kerr = cdev_add(k_cdev, MKDEV(kasumi_major, 0), 1);
> +    if (kerr < 0)
> +        return kerr;
> +
> +    /*
> +     * setup register base address
> +     */
> +    kasumi_base = ioremap64(0x0E0180000ULL, 0x80);
> +    if (!kasumi_base) {
> +        printk(KERN_INFO "ioremap falied for address 0xE0180000\n");
> +        return -1;
> +    }
> +
> +    /*
> +     **Register address assignments
> +     **
> +     */
> +    kreg.ctrl = ((uint *) ((u8 *) kasumi_base + KASU0_CTRL));
> +    kreg.status = ((uint *) ((u8 *) kasumi_base + KASU0_STATUS));
> +    kreg.mode = ((uint *) ((u8 *) kasumi_base + KASU0_MODE));
> +    kreg.key0 = ((uint *) ((u8 *) kasumi_base + KASU0_KEY0));
> +    kreg.key1 = ((uint *) ((u8 *) kasumi_base + KASU0_KEY1));
> +    kreg.key2 = ((uint *) ((u8 *) kasumi_base + KASU0_KEY2));
> +    kreg.key3 = ((uint *) ((u8 *) kasumi_base + KASU0_KEY3));
> +    kreg.count = ((uint *) ((u8 *) kasumi_base + KASU0_COUNT));
> +    kreg.config = ((uint *) ((u8 *) kasumi_base + KASU0_CONFIG));
> +    kreg.fresh = ((uint *) ((u8 *) kasumi_base + KASU0_FRESH));
> +    kreg.data_in0  = ((uint *) ((u8 *) kasumi_base + KASU0_DATA_IN0));
> +    kreg.data_in1 = ((uint *) ((u8 *) kasumi_base + KASU0_DATA_IN1));
> +    kreg.data_out0 = ((uint *) ((u8 *) kasumi_base + KASU0_DATA_OUT0));
> +    kreg.data_out1  = ((uint *) ((u8 *) kasumi_base + KASU0_DATA_OUT1));
> +
> +    /*
> +     ** reset KASUMI core
> +     */
> +    SDR_WRITE(SDR0_SRST1, SDR_READ(SDR0_SRST1) | KASUMI_RESET_MSK);
> +    SDR_WRITE(SDR0_SRST1, SDR_READ(SDR0_SRST1) & (~KASUMI_RESET_MSK));
> +    /*
> +     ** Disable the read pipe line. Otherwise it may cause hang on PLB
> +     */
> +    mtdcr(DCR_PLB4A0, mfdcr(DCR_PLB4A0) & DISABLE_RD_PIPE_LINE);
> +    mtdcr(DCR_UIC0_ER, (mfdcr(DCR_UIC0_ER) | 0x18000000));
> +
> +    /*
> +     ** Kasumi test
> +     */
> +#ifdef KASUMI_TEST
> +    kasumi_test();
> +    /*
> +     ** f8 mode
> +     */
> +    kasumi_test_f8_1();
> +    /*
> +     ** f9 mode
> +     */
> +    kasumi_test_f9();
> +#endif
> +    return 0;
> +}
> +
> +/*
> + * Cleanup module
> + */
> +void kasumi_cleanup_module(void)
> +{
> +    iounmap(kasumi_base);
> +    printk(KERN_INFO "Exiting Kasumi Driver\n");
> +}
>  +
> +EXPORT_SYMBOL(kasumi_f9_encrypt);
> +EXPORT_SYMBOL(kasumi_f8_encrypt);
> +EXPORT_SYMBOL(kasumi_encrypt);
> +EXPORT_SYMBOL(kasumi_decrypt);
> +module_init(kasumi_init_module);
> +module_exit(kasumi_cleanup_module);
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Tirumala Marri <tmarri@amcc.com>");
> +MODULE_DESCRIPTION("Kasumi security engine driver");
>
>
>
> --
> Marri T Reddy
> San Jose,CA
> No day but today



-- 
Marri T Reddy
San Jose,CA
No day but today

-
Linux-crypto:  cryptography in and on the Linux system
Archive:       http://mail.nl.linux.org/linux-crypto/
