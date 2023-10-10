Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037C5CD98C0
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 21:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjJJVnj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 17:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjJJVni (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 17:43:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155AB1FC9
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 14:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696974176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7j58jSxoMSjtICjzuYVhVJduEEO2aGmUt8x1byZkixA=;
        b=GDTfDVOPCXd43oTsdcDsVkG/8y49AlufqUt+7iV540QHPO4aR0ghFjdR3o7Lz6pjOJwH/w
        exyzAteNvx3WluFlMzk08FoBfocwIHRcaenyc4tPmHGfWFoY5OSqlFEHGzC6+dpRK13jff
        OmJR+qD51xjYUGA50Czp08/p5sjOZq4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-2LUMiXf0O2SFFihK2eyRaA-1; Tue, 10 Oct 2023 17:42:55 -0400
X-MC-Unique: 2LUMiXf0O2SFFihK2eyRaA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3172a94b274so4190277f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 14:42:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696974173; x=1697578973;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7j58jSxoMSjtICjzuYVhVJduEEO2aGmUt8x1byZkixA=;
        b=I9gGRDJuwdlsqzo8coloCLX6kERW+EIDXEezcIIGE2Lk+ENJXTZ8s3kFVmJGKfacQy
         E4LrsYx9J+AZZMadxAVTcrW3VbqkoAo9LP59Nlt8w8XFrRbut0IO3PlIGnG2AWHPjcmS
         UGeky4yiJHxZFJbKyVpvvGfnrZHWZ7oH3Nes8Pxv0rY32pG/C4oruO3M1SWTZxIHPCJM
         r/FJojuqqegGYlv882ZshBvf6He6866qxmt06nkXZgkTVD7T/Tsm4JfVUaSNXqdbEwoQ
         2GWWW91JOBhAMreyr0zDXe4Ucj0GJgHbvKa25tO9egDDNXyOkBvjcJF4RxAiSqTFFiwv
         eHpg==
X-Gm-Message-State: AOJu0YwC+acjKLwiUj1cy/foHjYOlHKhgeRaDQsBQoyFnnIN1qTjXGVL
        AGFDBIOmpESP7/bNuCO/I5sb4PUQvmdlM+Zui+J6i+BrFPLUp9HezKwvAu4BqKo4i+Kc42YlwhZ
        FhK3vg+1AI1Wxs9snwKgtAiCsvgkKWS8c
X-Received: by 2002:a5d:4486:0:b0:320:8291:5605 with SMTP id j6-20020a5d4486000000b0032082915605mr16776326wrq.2.1696974173609;
        Tue, 10 Oct 2023 14:42:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvlJv9piqdjwUmmSzkx4bf0GnL2+t+076ipCDe5oxu2XEBxAvFC4zjoEvDDXmhVt7SWixiKg==
X-Received: by 2002:a5d:4486:0:b0:320:8291:5605 with SMTP id j6-20020a5d4486000000b0032082915605mr16776313wrq.2.1696974173219;
        Tue, 10 Oct 2023 14:42:53 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id bv2-20020a0560001f0200b0032d09f7a713sm2878219wrb.18.2023.10.10.14.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 14:42:52 -0700 (PDT)
Date:   Tue, 10 Oct 2023 17:42:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Olivia Mackall <olivia@selenic.com>,
        Petre Eftime <petre.eftime@gmail.com>,
        Erdem Meydanlli <meydanli@amazon.nl>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v5] misc: Add Nitro Secure Module driver
Message-ID: <20231010174115-mutt-send-email-mst@kernel.org>
References: <20231010191815.13641-1-graf@amazon.com>
 <20231010163151-mutt-send-email-mst@kernel.org>
 <aa782a43-ad4a-455d-bc14-a6a6bb4022e0@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa782a43-ad4a-455d-bc14-a6a6bb4022e0@amazon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 10, 2023 at 11:29:00PM +0200, Alexander Graf wrote:
> 
> On 10.10.23 22:34, Michael S. Tsirkin wrote:
> > 
> > On Tue, Oct 10, 2023 at 07:18:15PM +0000, Alexander Graf wrote:
> > > When running Linux inside a Nitro Enclave, the hypervisor provides a
> > > special virtio device called "Nitro Security Module" (NSM). This device
> > > has 3 main functions:
> > > 
> > >    1) Provide attestation reports
> > >    2) Modify PCR state
> > >    3) Provide entropy
> > > 
> > > This patch adds a driver for NSM that exposes a /dev/nsm device node which
> > > user space can issue an ioctl on this device with raw NSM CBOR formatted
> > > commands to request attestation documents, influence PCR states, read
> > > entropy and enumerate status of the device. In addition, the driver
> > > implements a hwrng backend.
> > > 
> > > Originally-by: Petre Eftime <petre.eftime@gmail.com>
> > > Signed-off-by: Alexander Graf <graf@amazon.com>
> > Could some documentation about how this device works be posted on virtio
> > list please?
> 
> 
> Sure! What is your preferred method to provide this? :)
> 
> Alex
> 

Posting patch adding a text file with it to virtio-comment would be best.

> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 

