Return-Path: <SRS0=7/wf=D2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8002DC433E7
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 23:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C4FC2240C
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 23:05:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="R0THCPfe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388901AbgJSXFw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Oct 2020 19:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388894AbgJSXFv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Oct 2020 19:05:51 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB83C0613CE
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2020 16:05:49 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q9so54792iow.6
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2020 16:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KZcwJitFojA7RhzeD/UU8gbzehCBdvf6g5ia0ZYCrq4=;
        b=R0THCPfeT+NjRv5n7wRuWr3+iQQVH5mYQugrcFEorv7jMlZOJpq4gWO8x2sltRZ1S3
         8+uXkfK+0xraFRPc7RLEyC+L1Eqn+lwfgcQ60rCu3Ir6T0iqCUlHxkXPI8IxQxljNihW
         MxA7dERE+Fo0B6yhfEPLGm6gbjuMrGvt0ee7i4ozPAa6C0OwTV1SJBaz+sj8rzyyiIix
         DQ1LhxNguLsVQ2r9xWcmCur9QDHoeimXQtC/UVpN+4Yl8O9ZbpYKUwlrKFZtzYHwjpgZ
         iC+kREvCZvwgmOBCIm7DmgxG6/6ncKrp6QDCnbxkp/qIzrhuMyauJsg53LWTp//HSslk
         z+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KZcwJitFojA7RhzeD/UU8gbzehCBdvf6g5ia0ZYCrq4=;
        b=WmaGUjBuygMJiJUadpqo8zUtCaiaCjlRy36CPUubN7VvFaPOSG2O+kso1IdwJkHAGT
         swoKNGrO/U8owHcRdio8lLjwHF2mvcaXSL4ykUFPbdiNrvx8QNyEZmImIABx7WG4wm9S
         EmYq9DjAHaftvUD1HS6v1EZlpXfnNUwn0HfSdOo3Qmg3p1+DaXMsgAYkqcQShlc4dJFv
         DqkIPs7RsqARzoOAm8wey+R/IpbxLpQM82tolBZlpP0ao+OO0XRdDHc+EUSF1zUPdgj1
         EfSwJp6Q/sFB0JL0CP8To5p950LFFwwfcBSvVvxH7zS27WrmLCh1FfpBK5AioqHD7yIm
         PuiA==
X-Gm-Message-State: AOAM532Nah8ft5DtgInl14Y+nxGHgcR3EFcnbK2yXHxfEXuGoXo2Qvml
        XLTVgrZGe/tzrPpTuZ27apnBdg==
X-Google-Smtp-Source: ABdhPJwE/qhLAedndnNRaUrUDMs331Onaq8Iz+VDEVRJN+4h4B5ckC67pNXDnvS9MRF/DxLJjNlnIQ==
X-Received: by 2002:a6b:5019:: with SMTP id e25mr44377iob.123.1603148748578;
        Mon, 19 Oct 2020 16:05:48 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id u8sm7938ilm.36.2020.10.19.16.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 16:05:47 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kUeDq-002hRf-LL; Mon, 19 Oct 2020 20:05:46 -0300
Date:   Mon, 19 Oct 2020 20:05:46 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Tom Rix <trix@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-block@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-power@fi.rohmeurope.com, linux-gpio@vger.kernel.org,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        nouveau@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org, linux-iio@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        industrypack-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-can@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com, linux-nfc@lists.01.org,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-pci@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, patches@opensource.cirrus.com,
        storagedev@microchip.com, devel@driverdev.osuosl.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        linux-watchdog@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        bpf <bpf@vger.kernel.org>, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        alsa-devel@alsa-project.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        George Burgess <gbiv@google.com>
Subject: Re: [RFC] treewide: cleanup unreachable breaks
Message-ID: <20201019230546.GH36674@ziepe.ca>
References: <20201017160928.12698-1-trix@redhat.com>
 <20201018054332.GB593954@kroah.com>
 <CAKwvOdkR_Ttfo7_JKUiZFVqr=Uh=4b05KCPCSuzwk=zaWtA2_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkR_Ttfo7_JKUiZFVqr=Uh=4b05KCPCSuzwk=zaWtA2_Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 19, 2020 at 12:42:15PM -0700, Nick Desaulniers wrote:
> On Sat, Oct 17, 2020 at 10:43 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Sat, Oct 17, 2020 at 09:09:28AM -0700, trix@redhat.com wrote:
> > > From: Tom Rix <trix@redhat.com>
> > >
> > > This is a upcoming change to clean up a new warning treewide.
> > > I am wondering if the change could be one mega patch (see below) or
> > > normal patch per file about 100 patches or somewhere half way by collecting
> > > early acks.
> >
> > Please break it up into one-patch-per-subsystem, like normal, and get it
> > merged that way.
> >
> > Sending us a patch, without even a diffstat to review, isn't going to
> > get you very far...
> 
> Tom,
> If you're able to automate this cleanup, I suggest checking in a
> script that can be run on a directory.  Then for each subsystem you
> can say in your commit "I ran scripts/fix_whatever.py on this subdir."
>  Then others can help you drive the tree wide cleanup.  Then we can
> enable -Wunreachable-code-break either by default, or W=2 right now
> might be a good idea.

I remember using clang-modernize in the past to fix issues very
similar to this, if clang machinery can generate the warning, can't
something like clang-tidy directly generate the patch?

You can send me a patch for drivers/infiniband/* as well

Thanks,
Jason
