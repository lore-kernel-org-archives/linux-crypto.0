Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A05CDB484
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Oct 2023 05:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjJMFDK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Oct 2023 01:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjJMFDJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Oct 2023 01:03:09 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957CFC9
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 22:03:06 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-3232be274a0so1847713f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 22:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1697173385; x=1697778185; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UVpd0E4GFx6H/SM7YV3uveoOWkdUC4wwz8FAahExBkA=;
        b=RFbKBnHDCyktRRB57c8Fy81XmruDZuU0iBvedpxokaFQAg/X3OcvG7Z8qH5+8qmLJC
         NKIzdQfKKUec13eemPEIPSAxBCFTLPosnixtOqHzXxx0OSCK3GclprQj6R71ZMT51Uo9
         SDkcVohf7dPmjEHSdH0DBrTHAP2Vqdk4kBKgrlR/gki1HpX55HF4iI0r82uIG4rLPo+A
         dqCv5GabtcL0w3yaxA4aFyJdXpR9WZpULD0eveJ7Z/57nvwq/jl3szm2ZwRm/quRAEin
         To5XH2S4eCryqXdSALjPxPYTrBnlyIld+g35x4FRfaHl04/yYCBFwnlTFcQp8Ctram0D
         hLbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697173385; x=1697778185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UVpd0E4GFx6H/SM7YV3uveoOWkdUC4wwz8FAahExBkA=;
        b=suAgJaHrrkn/QHFx1n2spn3ihggZmSExHRwqInTNk0LBTiGmnOGQ7f1be3ppWqt1BB
         nMN5jGZhLNC3KCvrgkralK+Y7h2EjJVYXNLFDRvHOsMwIGLRmv1h4jyjjd/+UBXidP8K
         vpfRaUNxnW6isiyl2+7+Annu5nhK98LY/jGUkPTRspaMA5kfQ6koUUNRKCWqEo0rmudq
         kRRGCtx2+DKN+SKKDbiNfVidsbD5+Bqv0OSEX/u6TxOHoAEj9xPdlWPxakRYzP43rMFi
         q2kevIkZUgKYyDRX0o/VlRnc2gH5x9I2k+zYdPhdILL/AeqsGPbtFjGFczLfmqWFDf8L
         HjrQ==
X-Gm-Message-State: AOJu0Yy0v1Ct6M4dSmpYbxiJ0LuRaSeAIoYQYTY+kaHAp5MG0cAfKES2
        WT3jyHOqY6afHjO7ACeoynbqjw==
X-Google-Smtp-Source: AGHT+IEvea4eYbGIhMcMt7pht9MZ6rkBFbtUuvgV/OJhcSTlZKOMEd1P7WHPPrbIAstniFTyYUMHUA==
X-Received: by 2002:adf:fb47:0:b0:318:416:a56a with SMTP id c7-20020adffb47000000b003180416a56amr17734101wrs.13.1697173384872;
        Thu, 12 Oct 2023 22:03:04 -0700 (PDT)
Received: from vermeer ([2a01:cb1d:81a9:dd00:b570:b34c:ffd4:c805])
        by smtp.gmail.com with ESMTPSA id u5-20020a05600c00c500b004063c9f68f2sm1455494wmm.26.2023.10.12.22.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 22:03:04 -0700 (PDT)
Date:   Fri, 13 Oct 2023 07:03:01 +0200
From:   Samuel Ortiz <sameo@rivosinc.com>
To:     Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy <aik@amd.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 00/12] PCI device authentication
Message-ID: <ZSjPhTJ9N0EKH5+W@vermeer>
References: <cover.1695921656.git.lukas@wunner.de>
 <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
 <20231007100433.GA7596@wunner.de>
 <20231009123335.00006d3d@Huawei.com>
 <20231009134950.GA7097@wunner.de>
 <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
 <20231012091542.GA22596@wunner.de>
 <ZSfw+xswgOSaYxgW@vermeer>
 <20231012163221.000064af@Huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012163221.000064af@Huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 12, 2023 at 04:32:21PM +0100, Jonathan Cameron wrote:
> On Thu, 12 Oct 2023 15:13:31 +0200
> Samuel Ortiz <sameo@rivosinc.com> wrote:
> 
> > On Thu, Oct 12, 2023 at 11:15:42AM +0200, Lukas Wunner wrote:
> > > On Tue, Oct 10, 2023 at 03:07:41PM +1100, Alexey Kardashevskiy wrote:  
> > > > But the way SPDM is done now is that if the user (as myself) wants to let
> > > > the firmware run SPDM - the only choice is disabling CONFIG_CMA completely
> > > > as CMA is not a (un)loadable module or built-in (with some "blacklist"
> > > > parameters), and does not provide a sysfs knob to control its tentacles.
> > > > Kinda harsh.  
> > > 
> > > On AMD SEV-TIO, does the PSP perform SPDM exchanges with a device
> > > *before* it is passed through to a guest?  If so, why does it do that?  
> > 
> > SPDM exchanges would be done with the DSM, i.e. through the PF, which is
> > typically *not* passed through to guests. VFs are.
> > 
> > The RISC-V CoVE-IO [1] spec follows similar flows as SEV-TIO (and to
> > some extend TDX-Connect) and expects the host to explicitly request the
> > TSM to establish an SPDM connection with the DSM (PF) before passing one
> > VF through a TSM managed guest. VFs would be vfio bound, not the PF, so
> > I think patch #12 does not solve our problem here. 
> > 
> > > Dan and I discussed this off-list and Dan is arguing for lazy attestation,
> > > i.e. the TSM should only have the need to perform SPDM exchanges with
> > > the device when it is passed through.
> > > 
> > > So the host enumerates the DOE protocols and authenticates the device.
> > > When the device is passed through, patch 12/12 ensures that the host
> > > keeps its hands off of the device, thus affording the TSM exclusive
> > > SPDM control.  
> > 
> > Just to re-iterate: The TSM does not talk SPDM with the passed
> > through device(s), but with the corresponding PF. If the host kernel
> > owns the SPDM connection when the TSM initiates the SPDM connection with
> > the DSM (For IDE key setup), the connection establishment will fail.
> > Both CoVE-IO and SEV-TIO (Alexey, please correct me if I'm wrong)
> > expect the host to explicitly ask the TSM to establish that SPDM
> > connection. That request should somehow come from KVM, which then would
> > have to destroy the existing CMA/SPDM connection in order to give the
> > TSM a chance to successfully establish the SPDM link.
> 
> Agreed - I don't see a problem with throwing away the initial connection.
> In these cases you are passing that role on to another entity - the
> job of this patch set is done.

Right. As long as there's a way for the kernel to explicitly drop that
ownership before calling into the TSM for asking it to create a new SPDM
connection, we should be fine. Alexey, would you agree with that
statement?

> I'm not clear yet if we need an explicit lock out similar to the VFIO
> one for PF pass through or if everything will happen in a 'safe' order
> anyway. I suspect a lockout on the ability to re attest is necessary
> if the PF driver is loaded.
>
> Perhaps just dropping the
> +#if IS_ENABLED(CONFIG_VFIO_PCI_CORE)
> and letting other PF drivers or another bit of core kernel code
> (I'm not sure where the proxy resides for the models being discussed)
> claim ownership is enough?

If we agree that other parts of the kernel (I suspect KVM would do the
"Connect to device" call to the TSM) should be able to tear the
established SPDM connection, then yes, the claim/return_ownership() API
should not be only available to VFIO.

Cheers,
Samuel.
