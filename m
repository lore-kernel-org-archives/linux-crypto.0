Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33674 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbfAKJjI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 04:39:08 -0500
Received: by mail-wm1-f66.google.com with SMTP id r24so1580468wmh.0
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2019 01:39:06 -0800 (PST)
Date: Fri, 11 Jan 2019 09:39:02 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Sumit Garg <sumit.garg@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Jens Wiklander <jens.wiklander@linaro.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Subject: Re: [PATCH v2 2/4] tee: optee: add TEE bus device enumeration support
Message-ID: <20190111093902.hfxb67txjhhlegzu@holly.lan>
References: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
 <1547123097-16431-3-git-send-email-sumit.garg@linaro.org>
 <20190110141856.p3evqyf34py74gkg@holly.lan>
 <CAFA6WYPHmtY4N9ruGLZ70FNeiDCbQE-fs+EP2px-S+GEj2nPTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYPHmtY4N9ruGLZ70FNeiDCbQE-fs+EP2px-S+GEj2nPTw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 11, 2019 at 12:52:19PM +0530, Sumit Garg wrote:
> On Thu, 10 Jan 2019 at 19:49, Daniel Thompson
> <daniel.thompson@linaro.org> wrote:
> > > +static int get_devices(struct tee_context *ctx, u32 session,
> > > +                    struct tee_shm *device_uuid, u32 *shm_size)
> >
> > Missing const on device_uuid?
> >
> 
> I don't think we should have a const for device_uuid here as this is
> shared memory struct pointer which is dynamically allocated and used
> to fetch device UUIDs.

Agree. Perhaps device_uuid is misnamed though (part of the reason I
misread this is that it is singular so I though it was a single UUID
travelling into the TZ).

> > > +     rc = get_devices(ctx, sess_arg.session, device_shm, &shm_size);
> > > +     if (rc < 0)
> > > +             goto out_shm;
> > > +
> > > +     device_uuid = tee_shm_get_va(device_shm, 0);
> > > +     if (IS_ERR(device_uuid)) {
> > > +             pr_err("tee_shm_get_va failed\n");
> > > +             rc = PTR_ERR(device_uuid);
> > > +             goto out_shm;
> > > +     }
> > > +
> > > +     while (idx < shm_size / sizeof(uuid_t)) {
> >
> > This is a very uncommon way to write a for loop ;-).
> >
> 
> Ok, will add "num_devices" variable.

num_devices might add readability but that is not what I meant.

The most idiomatic way to write somthing that loops for every valid index
value is:

	for (i=0; i < limit; i++)

You wrote it like this:

	int idx=0;

	/* lots of code between initializer and first use */

	while (idx < limit) {
		/* more code */
		idx++;
	}

Sure, they are equivalent but the idiomatic form is easier to read.


Daniel.
