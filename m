Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52045C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Feb 2022 15:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbiBYPqd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Feb 2022 10:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbiBYPqc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Feb 2022 10:46:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DEE1FCC3;
        Fri, 25 Feb 2022 07:46:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CC97B83253;
        Fri, 25 Feb 2022 15:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815F5C340E7;
        Fri, 25 Feb 2022 15:45:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DbUu57ez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645803954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aXuTEAnaE0aPUjDR2q7+fL3WYM8X+IEQPCKcmMJb3HY=;
        b=DbUu57ezzxPejz+zfBx1TQmqkahBb9aDLTCQTad2Lww+7tJ0meOvgVrM21yxrInKocw3wZ
        +5YznIsBNOd+8/9KWpwTpoOt+Jd8q5buE2GzqjEicIF52FB0TmtxdmuWqJVmEIwrjB/acl
        zAALZjfU+gvOO4jXeIuJ1BAFSjLODjA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c5031fcd (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 15:45:54 +0000 (UTC)
Date:   Fri, 25 Feb 2022 16:45:50 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, adrian@parity.io,
        KVM list <kvm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-hyperv@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ben@skyportsystems.com,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        Eric Biggers <ebiggers@kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Jann Horn <jannh@google.com>,
        KY Srinivasan <kys@microsoft.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Weiss, Radu" <raduweis@amazon.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing
 RNG on VM fork
Message-ID: <Yhj5rg2Cgv+qRcjc@zx2c4.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjjuMOeV7+T7thS@zx2c4.com>
 <88ebdc32-2e94-ef28-37ed-1c927c12af43@amazon.com>
 <YhjoyIUv2+18BwiR@zx2c4.com>
 <9ac68552-c1fc-22c8-13e6-4f344f85a4fb@amazon.com>
 <CAMj1kXEue6cDCSG0N7WGTVF=JYZx3jwE7EK4tCdhO-HzMtWwVw@mail.gmail.com>
 <Yhj288aE5rW15Qpj@zx2c4.com>
 <b6c5c4d4-88a5-1ac5-a4d4-2f6895065834@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b6c5c4d4-88a5-1ac5-a4d4-2f6895065834@amazon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Alex,

On Fri, Feb 25, 2022 at 04:37:43PM +0100, Alexander Graf wrote:
> I believe "VMGENID" was for the firecracker prototype that Adrian built 
> back then, yeah. Matching on _HID for this is a rat hole unfortunately, 
> so let's see what the ACPI patch gets us :).

Thanks. I'll add a comment to the code about Firecracker. And indeed
hopefully that'll all go away anyway.

Jason
