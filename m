From: Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [RFC PATCH 1/3] crypto: zip - Add ThunderX ZIP driver core
Date: Mon, 19 Dec 2016 11:12:21 -0500
Message-ID: <CA+1xoqcVXx1qBN_pk3n93GRFjHHZzuz=3SCVW9oV3_gqFBQRhA@mail.gmail.com>
References: <20161212150439.18627-1-jglauber@cavium.com> <20161212150439.18627-2-jglauber@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mahipal Challa <Mahipal.Challa@cavium.com>,
        Vishnu Nair <Vishnu.Nair@cavium.com>
To: Jan Glauber <jglauber@cavium.com>, alexander.levin@verizon.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161212150439.18627-2-jglauber@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 12, 2016 at 10:04 AM, Jan Glauber <jglauber@cavium.com> wrote:
> +/* error messages */
> +#define zip_err(fmt, args...) pr_err("ZIP ERR:%s():%d: " \
> +                             fmt "\n", __func__, __LINE__, ## args)
> +
> +#ifdef MSG_ENABLE
> +/* Enable all messages */
> +#define zip_msg(fmt, args...) pr_info("ZIP_MSG:" fmt "\n", ## args)
> +#else
> +#define zip_msg(fmt, args...)
> +#endif
> +
> +#if defined(ZIP_DEBUG_ENABLE) && defined(MSG_ENABLE)
> +
> +#ifdef DEBUG_LEVEL
> +
> +#define FILE_NAME (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : \
> +       strrchr(__FILE__, '\\') ? strrchr(__FILE__, '\\') + 1 : __FILE__)
> +
> +#if DEBUG_LEVEL >= 4
> +
> +#define zip_dbg(fmt, args...) pr_info("ZIP DBG: %s: %s() : %d: " \
> +                             fmt "\n", FILE_NAME, __func__, __LINE__, ## args)
> +
> +#define zip_dbg_enter(fmt, args...) pr_info("ZIP_DBG: %s() in %s" \
> +                                   fmt "\n", __func__, FILE_NAME, ## args)
> +
> +#define zip_dbg_exit(fmt, args...) pr_info("ZIP_DBG:Exit %s() in %s" \
> +                                  fmt "\n", __func__, FILE_NAME, ## args)
> +
> +#elif DEBUG_LEVEL >= 3
> +
> +#define zip_dbg(fmt, args...) pr_info("ZIP DBG: %s: %s() : %d: " \
> +                             fmt "\n", FILE_NAME, __func__, __LINE__, ## args)
> +
> +#elif DEBUG_LEVEL >= 2
> +
> +#define zip_dbg(fmt, args...) pr_info("ZIP DBG: %s() : %d: " \
> +                             fmt "\n", __func__, __LINE__, ## args)
> +
> +#else
> +
> +#define zip_dbg(fmt, args...) pr_info("ZIP DBG:" fmt "\n", ## args)
> +
> +#endif /* DEBUG LEVEL >= */
> +
> +#if DEBUG_LEVEL <= 3
> +
> +#define zip_dbg_enter(fmt, args...)
> +#define zip_dbg_exit(fmt, args...)
> +
> +#endif /* DEBUG_LEVEL <= 3 */
> +#else
> +
> +#define zip_dbg(fmt, args...) pr_info("ZIP DBG:" fmt "\n", ## args)
> +
> +#define zip_dbg_enter(fmt, args...)
> +#define zip_dbg_exit(fmt, args...)
> +
> +#endif /* DEBUG_LEVEL */
> +#else
> +
> +#define zip_dbg(fmt, args...)
> +#define zip_dbg_enter(fmt, args...)
> +#define zip_dbg_exit(fmt, args...)
> +
> +#endif /* ZIP_DEBUG_ENABLE */

The whole zip_dbg_[enter,exit] thing can be just done with tracepoints
instead of reinventing the wheel. No reason to carry that code

> +u32 zip_load_instr(union zip_inst_s *instr,
> +                  struct zip_device *zip_dev)
> +{
> +       union zip_quex_doorbell dbell;
> +       u32 queue = 0;
> +       u32 consumed = 0;
> +       u64 *ncb_ptr = NULL;
> +       union zip_nptr_s ncp;
> +
> +       /*
> +        * Distribute the instructions between the enabled queues based on
> +        * the CPU id.
> +        */
> +       if (raw_smp_processor_id() % 2 == 0)
> +               queue = 0;
> +       else
> +               queue = 1;

Is this just simplistic load balancing scheme? There's no guarantee
that the cpu won't change later on.

> +
> +       /* Poll for the IQ cmd completion code */
> +       zip_dbg_exit();

The comment doesn't match with what actually happens?

> +static inline u64 zip_depth(void)
> +{
> +       struct zip_device *zip_dev = zip_get_device(zip_get_node_id());
> +
> +       if (!zip_dev)
> +               return -ENODEV;
> +
> +       return zip_dev->depth;
> +}
> +
> +static inline u64 zip_onfsize(void)
> +{
> +       struct zip_device *zip_dev = zip_get_device(zip_get_node_id());
> +
> +       if (!zip_dev)
> +               return -ENODEV;
> +
> +       return zip_dev->onfsize;
> +}
> +
> +static inline u64 zip_ctxsize(void)
> +{
> +       struct zip_device *zip_dev = zip_get_device(zip_get_node_id());
> +
> +       if (!zip_dev)
> +               return -ENODEV;
> +
> +       return zip_dev->ctxsize;
> +}

Where is it all used?

> +/*
> + * Allocates new ZIP device structure
> + * Returns zip_device pointer or NULL if cannot allocate memory for zip_device
> + */
> +static struct zip_device *zip_alloc_device(struct pci_dev *pdev)
> +{
> +       struct zip_device *zip = NULL;
> +       int idx = 0;
> +
> +       for (idx = 0; idx < MAX_ZIP_DEVICES; idx++) {
> +               if (!zip_dev[idx])
> +                       break;
> +       }
> +
> +       zip = kzalloc(sizeof(*zip), GFP_KERNEL);
> +
> +       if (!zip)
> +               return NULL;
> +
> +       zip_dev[idx] = zip;

If for some odd reason we try to allocate more than MAX_ZIP_DEVICES
this will deref an invalid pointer.

> +/**
> + * zip_get_device - Get ZIP device based on node id of cpu
> + *
> + * @node: Node id of the current cpu
> + * Return: Pointer to Zip device structure
> + */
> +struct zip_device *zip_get_device(int node)
> +{
> +       if ((node < MAX_ZIP_DEVICES) && (node >= 0))
> +               return zip_dev[node];
> +
> +       zip_err("ZIP device not found for node id %d\n", node);
> +       return NULL;
> +}
> +
> +/**
> + * zip_get_node_id - Get the node id of the current cpu
> + *
> + * Return: Node id of the current cpu
> + */
> +int zip_get_node_id(void)
> +{
> +       return cpu_to_node(raw_smp_processor_id());
> +}

This looks off: why are you calling raw_smp_processor_id() instead of
just smp_processor_id()?

I guess you saw warnings from smp_processor_id(), but they happen to
warn you that the cpu might change under you, making this node number
incorrect.


> +#ifndef __ZIP_MAIN_H__
> +#define __ZIP_MAIN_H__
> +
> +#include "zip_device.h"
> +#include "zip_regs.h"
> +
> +/* PCI device IDs */
> +#define PCI_DEVICE_ID_THUNDERX_ZIP   0xA01A
> +
> +/* ZIP device BARs */
> +#define PCI_CFG_ZIP_PF_BAR0   0  /* Base addr for normal regs */
> +#define PCI_CFG_ZIP_PF_BAR4   4  /* Base addr for MSI-X regs  */
> +
> +/* Maximum available zip queues */
> +#define ZIP_MAX_NUM_QUEUES    8
> +#define ZIP_MAXQ_PER_ZIPENG   4
> +#define ZIP_NUMENG_CN88XX     2
> +
> +#define ZIP_128B_ALIGN        7
> +
> +/* Buffer size and alignment */
> +#define ZIP_CMD_QBUF_SIZE     (8064 + 8)
> +#define ZIP_CMD_QBUF_ALIGN    128
> +#define ZIP_DATA_BUF_ALIGN    8
>
> +/*
> + * There will be max of 2^20 zip cmds in the zip instruction queue.
> + * So no of zip Chunk buffers = ((2^20) / ((2*1024)/64))
> + */
> +#define ZIP_MAX_CMD           (1024 * 1024)
> +#define ZIP_CMD_PER_BUF       (ZIP_CMD_QBUF_SIZE / 64)
> +#define ZIP_CMD_QBUF_MAX_CNT  (1 * 1024)
> +
> +/* Data buffer size 64K for time being */
> +#define ZIP_DATA_BUF_SIZE     (64 * 1024)
> +
> +/* Number of data buffers */
> +#define ZIP_DATA_BUF_CNT      (32 * 1024)

Bunch of these defines aren't used.

> +/**
> + * zip_cmd_qbuf_alloc - Allocates a cmd buffer for ZIP Instruction Queue
> + * @zip: Pointer to zip device structure
> + * @q:   Queue number to allocate bufffer to
> + * Return: 0 if successful, -ENOMEM otherwise
> + */
> +int zip_cmd_qbuf_alloc(struct zip_device *zip, int q)
> +{
> +       zip_dbg_enter();
> +
> +       zip->iq[q].sw_head = (u64 *)__get_free_pages((GFP_KERNEL | GFP_DMA),
> +                                               get_order(ZIP_CMD_QBUF_SIZE));
> +
> +       if (!zip->iq[q].sw_head)
> +               return -ENOMEM;
> +
> +       memset(zip->iq[q].sw_head, 0, ZIP_CMD_QBUF_SIZE);
> +
> +       zip_dbg("cmd_qbuf_alloc[%d] Success : %p\n", q, zip->iq[q].sw_head);
> +       zip_dbg_exit();
> +       return 0;
> +}
> +
> +/**
> + * zip_cmd_qbuf_free - Frees the cmd Queue buffer
> + * @zip: Pointer to zip device structure
> + * @q:   Queue number to free buffer of
> + */
> +void zip_cmd_qbuf_free(struct zip_device *zip, int q)
> +{
> +       zip_dbg("Freeing cmd_qbuf 0x%lx\n", zip->iq[q].sw_tail);
> +
> +       free_pages((u64)zip->iq[q].sw_tail, get_order(ZIP_CMD_QBUF_SIZE));
> +}

Why are you going through __get_free_pages() for constant size
allocations? kmemcache would be better here.

> +/**
> + * zip_data_buf_alloc - Allocates memory for a data bufffer
> + * @size:   Size of the buffer to allocate
> + * Returns: Pointer to the buffer allocated
> + */
> +u8 *zip_data_buf_alloc(u64 size)
> +{
> +       u8 *ptr;
> +
> +       zip_dbg_enter();
> +
> +       ptr = (u8 *)__get_free_pages((GFP_ATOMIC | GFP_DMA),
> +                                       get_order(size));
> +
> +       if (!ptr)
> +               return NULL;
> +
> +       memset(ptr, 0, size);
> +
> +       zip_dbg("Data buffer allocation success\n");
> +       zip_dbg_exit();
> +       return ptr;
> +}
> +
> +/**
> + * zip_data_buf_free - Frees the memory of a data buffer
> + * @ptr:  Pointer to the buffer
> + * @size: Buffer size
> + */
> +void zip_data_buf_free(u8 *ptr, u64 size)
> +{
> +       zip_dbg("Freeing data buffer 0x%lx\n", ptr);
> +
> +       free_pages((u64)ptr, get_order(size));
> +}

Same question here; you end up allocating constant sizes - why not kmemcache?

Also, this is quite a lot to allocate out of the atomic pool, is there
a reason for that?


Thanks,
Sasha
