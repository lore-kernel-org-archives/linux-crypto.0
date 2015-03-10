From: Andrew Bresticker <abrestic@chromium.org>
Subject: Re: [PATCH V3 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Tue, 10 Mar 2015 11:02:26 -0700
Message-ID: <CAL1qeaF+h-pEpWiC1h=RA8ei9i_wbw997WM-dPq-sfW_RjK7eg@mail.gmail.com>
References: <1425610912-9930-1-git-send-email-james.hartley@imgtec.com>
	<1425610912-9930-2-git-send-email-james.hartley@imgtec.com>
	<CAL1qeaEedjW7A8npCrmnOWByM6gOL2JA8c=Pa8Y9wOYnmz8NcA@mail.gmail.com>
	<72BC0C8BD7BB6F45988A99382E5FBAE544463666@hhmail02.hh.imgtec.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: James Hartley <James.Hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:41725 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbbCJSC1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2015 14:02:27 -0400
Received: by qgea108 with SMTP id a108so3926457qge.8
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2015 11:02:26 -0700 (PDT)
In-Reply-To: <72BC0C8BD7BB6F45988A99382E5FBAE544463666@hhmail02.hh.imgtec.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

>> > +static irqreturn_t img_irq_handler(int irq, void *dev_id) {
>> > +       struct img_hash_dev *hdev = dev_id;
>> > +       u32 reg;
>> > +
>> > +       reg = img_hash_read(hdev, CR_INTSTAT);
>> > +       img_hash_write(hdev, CR_INTCLEAR, reg);
>> > +
>> > +       if (reg & CR_INT_NEW_RESULTS_SET) {
>> > +               dev_dbg(hdev->dev, "IRQ CR_INT_NEW_RESULTS_SET\n");
>> > +               if (DRIVER_FLAGS_BUSY & hdev->flags) {
>> > +                       hdev->flags |= DRIVER_FLAGS_OUTPUT_READY;
>> > +                       if (!(DRIVER_FLAGS_CPU & hdev->flags))
>> > +                               hdev->flags |= DRIVER_FLAGS_DMA_READY;
>> > +                       tasklet_schedule(&hdev->done_task);
>>
>> Since this done_task only gets scheduled from here, why not make this a
>> threaded IRQ handler and just do the work here instead of separating it
>> between a hard IRQ handler and a tasklet?
>
> What is the advantage of doing that?  i.e is this simple case worth setting up an extra thread?

I believe threaded IRQ handlers are now preferred to using a hard IRQ
handler + tasklet when possible, partly because people tend to screw
up tasklet usage.

>> > +               err = PTR_ERR(hdev->io_base);
>> > +               goto hash_io_err;
>> > +       }
>> > +
>> > +       /* Write port (DMA or CPU) */
>> > +       hash_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> > +       if (!hash_res) {
>> > +               dev_err(dev, "no write port resource info\n");
>> > +               err = -ENODEV;
>> > +               goto res_err;
>> > +       }
>> > +       hdev->bus_addr = hash_res->start;
>>
>> Maybe set this after devm_ioremap_resource() succeeds and avoid the extra
>> error check?
>
> Not quite following you here - which check are you saying can be removed?

You can remove the if (hash_res) check if you set hdev->bus_addr after
devm_ioremap_resource().

Thanks,
Andrew
