Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DEDECDB482
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Oct 2023 13:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344014AbjJLNNi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Oct 2023 09:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343748AbjJLNNh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2023 09:13:37 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270CC91
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 06:13:36 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-405361bba99so9442555e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 06:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1697116414; x=1697721214; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IvfsuqeXvTAiiT0A6Kg2dLp8waVJkGZPJh+mIn+Z3lc=;
        b=asheKMbhbemLGughzEIK2P1pRezyMpbJ+eXyNW7ikkxvQl/0OOMsDeizR69PbNPKoD
         gA+pFBIUZqts/JPS+Bws5bzT9t68yxmfL63rSagkjjRCZoMEA2uj1HRBrXqiU4uNTNHE
         k02PUV5/zUrXuscDmzgYTKJmjl1BcTUn0NYKifoCEWg+LfhkfrVSsITk32iXpGHROFVR
         fZRq+t1KWjkfRssUBOu0ZWlBOqZ7H7OVCAgvSKP9H8+k/SWoiptYMnuoAvE1ENe5Il7f
         TxWXCbu738HD7oeLjreqERgr7eyw/nEwHaLBR//Ru6vA4N5KTDrkAUfom4og2uVqVUNm
         26uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697116414; x=1697721214;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvfsuqeXvTAiiT0A6Kg2dLp8waVJkGZPJh+mIn+Z3lc=;
        b=HETCSmNbZKwLS/xZk6i7p4RyVfksTV8sakHAHDB84o2TkpTDl1CNfssSnf3j7S4VmF
         ZUVtP9pIXIQTBivUlM2mk+r2Mp7fKyES0/ejpQHMnue7CQiPmcw5ewS7iM7Mb84r4OiR
         Qc71FiTK1F6HRdLrXzeiKrrwZQWWhOZXfxW+PU9q+8pyMfBqN47FTaOA6QV7ybiDeaz9
         xonfVvbvjq5qSB7kq0SEEQIDXy7paPRi6sGyWJK85hIvdQvXBZrxMColvCvOzNPkdYtv
         oS5v3Gxgt1onKTHJieFel6WZAM0BE9T1wA4hVKPBeUWcblFzqfDWsRnW17wwaVMnCab/
         0PqQ==
X-Gm-Message-State: AOJu0YzYqq+JHLF6FEIdrPLxV8jIC3oH54TI6rWKr5HO/7nJ+C0OBvJq
        ppsSrmhLzlgmZA7vr3HRKYoJiTJcMDcoIToPiWpOcA==
X-Google-Smtp-Source: AGHT+IFDkAeW7u7CFaRSTjjZPVGdE97IuC3OvNH39GloKvqqSstnsBhwBW7Tc7zhg48/jzIDrvVQig==
X-Received: by 2002:a05:600c:255:b0:405:3d83:2b76 with SMTP id 21-20020a05600c025500b004053d832b76mr20973611wmj.13.1697116414527;
        Thu, 12 Oct 2023 06:13:34 -0700 (PDT)
Received: from vermeer ([2a01:cb1d:81a9:dd00:b570:b34c:ffd4:c805])
        by smtp.gmail.com with ESMTPSA id l17-20020a1ced11000000b0040588d85b3asm21637965wmh.15.2023.10.12.06.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 06:13:34 -0700 (PDT)
Date:   Thu, 12 Oct 2023 15:13:31 +0200
From:   Samuel Ortiz <sameo@rivosinc.com>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Alexey Kardashevskiy <aik@amd.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
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
Message-ID: <ZSfw+xswgOSaYxgW@vermeer>
References: <cover.1695921656.git.lukas@wunner.de>
 <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
 <20231007100433.GA7596@wunner.de>
 <20231009123335.00006d3d@Huawei.com>
 <20231009134950.GA7097@wunner.de>
 <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
 <20231012091542.GA22596@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012091542.GA22596@wunner.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 12, 2023 at 11:15:42AM +0200, Lukas Wunner wrote:
> On Tue, Oct 10, 2023 at 03:07:41PM +1100, Alexey Kardashevskiy wrote:
> > But the way SPDM is done now is that if the user (as myself) wants to let
> > the firmware run SPDM - the only choice is disabling CONFIG_CMA completely
> > as CMA is not a (un)loadable module or built-in (with some "blacklist"
> > parameters), and does not provide a sysfs knob to control its tentacles.
> > Kinda harsh.
> 
> On AMD SEV-TIO, does the PSP perform SPDM exchanges with a device
> *before* it is passed through to a guest?  If so, why does it do that?

SPDM exchanges would be done with the DSM, i.e. through the PF, which is
typically *not* passed through to guests. VFs are.

The RISC-V CoVE-IO [1] spec follows similar flows as SEV-TIO (and to
some extend TDX-Connect) and expects the host to explicitly request the
TSM to establish an SPDM connection with the DSM (PF) before passing one
VF through a TSM managed guest. VFs would be vfio bound, not the PF, so
I think patch #12 does not solve our problem here. 

> Dan and I discussed this off-list and Dan is arguing for lazy attestation,
> i.e. the TSM should only have the need to perform SPDM exchanges with
> the device when it is passed through.
> 
> So the host enumerates the DOE protocols and authenticates the device.
> When the device is passed through, patch 12/12 ensures that the host
> keeps its hands off of the device, thus affording the TSM exclusive
> SPDM control.

Just to re-iterate: The TSM does not talk SPDM with the passed
through device(s), but with the corresponding PF. If the host kernel
owns the SPDM connection when the TSM initiates the SPDM connection with
the DSM (For IDE key setup), the connection establishment will fail.
Both CoVE-IO and SEV-TIO (Alexey, please correct me if I'm wrong)
expect the host to explicitly ask the TSM to establish that SPDM
connection. That request should somehow come from KVM, which then would
have to destroy the existing CMA/SPDM connection in order to give the
TSM a chance to successfully establish the SPDM link.

Cheers,
Samuel.

[1] https://github.com/riscv-non-isa/riscv-ap-tee-io/blob/main/specification/07-theory_operations.adoc
> 
