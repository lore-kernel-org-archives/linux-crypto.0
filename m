Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1825BC433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 09:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B84C220725
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 09:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbhAUJyj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 04:54:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbhAUJxn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 04:53:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C04F239D3;
        Thu, 21 Jan 2021 09:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611222778;
        bh=a08eyup4zJE1nHo7/wnywsrNQvl9GOKRtX1mXLpx1cc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qUI/+bor81BVLA2oAEt3YXH61AuVXFOqs2vML32Oky6wuoxgHJTd18vJBOkpF14tD
         FMCbb4sL+FJAIkCk7llaN91kgfjZhelcLDXVTS0zTBmXlwIFG+GqcFm6lrl31vJ+59
         vRCU7HKQVoiQbgzcO9AZAdjyt5727YTY1CL53PHK7VrOAlrQE3l9i95c0E9p9Et3Hx
         Qok7dHzPEd3dTDMjzzgwmfQgJA3qk2z6OXwX13ijUmrcjbwVqKxdvMzb0VMdMCHVxE
         yH+TaPNaS/9CojxbC8euWxee2FJTWNZl/bik4oNljk73NwXkeIABN3cX5PrDHRfhEa
         6pQXJPNvtpdxw==
Received: by mail-oi1-f177.google.com with SMTP id r189so1537640oih.4;
        Thu, 21 Jan 2021 01:52:58 -0800 (PST)
X-Gm-Message-State: AOAM531hLDQYdXyTa8cHEGD/OeBulQ5VLXLvxKOOM1eDnvFa0mrP50R5
        vefX8OMnxccjSYxVuRlRA6TO2u369FeL1B/Z6e4=
X-Google-Smtp-Source: ABdhPJxZ6Cr+9tUOMy2rww2iNs0wN+clKncz07X1bCQJ+ajvUIdUWeMJH4iHBFIhPXqVmnhbjr1EtkypNriDJ2IKQ98=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr5525447oig.33.1611222777308;
 Thu, 21 Jan 2021 01:52:57 -0800 (PST)
MIME-Version: 1.0
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
 <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <20210104113148.GA20575@gondor.apana.org.au> <CY4PR1101MB23260DF5A317CA05BBA3C2F9E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <CY4PR1101MB232696B49BA1A3441E8B335EE7A80@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <CAMj1kXH9sHm_=dXS7646MbPQoQST9AepfHORSJgj0AxzWB4SvQ@mail.gmail.com>
 <CY4PR1101MB232656080E3F457EC345E7B2E7A40@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <CAMj1kXF9yUVEdPeF6EUCSOdb44HdFuVPk6G2cKOAUAn-mVjCzw@mail.gmail.com> <7ae7890f52226e75bf9e368808d6377e8c5efc2d.camel@intel.com>
In-Reply-To: <7ae7890f52226e75bf9e368808d6377e8c5efc2d.camel@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 21 Jan 2021 10:52:46 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE8TnHvZrp2NQv9SJ4CfUOxy1sVXVusjrSWaiXOjRTQ5g@mail.gmail.com>
Message-ID: <CAMj1kXE8TnHvZrp2NQv9SJ4CfUOxy1sVXVusjrSWaiXOjRTQ5g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
To:     "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
Cc:     "Reshetova, Elena" <elena.reshetova@intel.com>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Jan 2021 at 20:00, Alessandrelli, Daniele
<daniele.alessandrelli@intel.com> wrote:
>
> Hi Ard,
>
> Thank you very much for your valuable feedback.
>
> On Mon, 2021-01-18 at 13:09 +0100, Ard Biesheuvel wrote:
> > This is rather unusual compared with how the crypto API is typically
> > used, but if this is really what you want to implement, you can do so
> > by:
> > - having a "ecdh" implementation that implements the entire range, and
> > uses a fallback for curves that it does not implement
> > - export the same implementation again as "ecdh" and with a known
> > driver name "ecdh-keembay-ocs", but with a slightly lower priority,
> > and in this case, return an error when the unimplemented curve is
> > requested.
> >
> > That way, you fully adhere to the API, by providing implementations of
> > all curves by default. And if a user requests "ecdh-keembay-ocs"
> > explicitly, it will not be able to use the P192 curve inadvertently.
>
> I tried to implement this, but it looks like the driver name is
> mandatory, so I specified one also for the first implementation.
>
> Basically I defined two 'struct kpp_alg' variables; both with cra_name
> = "ecdh", but with different 'cra_driver_name' (one with
> cra_driver_name = "ecdh-keembay-ocs-fallback" and the other one with
> cra_driver_name = "ecdh-keembay-ocs").
>
> Is this what you were suggesting?
>
> Anyway, that works (i.e., 'ecdh-keembay-ocs' returns an error when the
> unimplemented curve is requested; while 'ecdh-keembay-ocs' and 'ecdh'
> work fine with any curve), but I have to set the priority of 'ecdh-
> keembay-ocs' to something lower than the 'ecdh_generic' priority.
> Otherwise the implementation with fallback ends up using my "ecdh-
> keembay-ocs" as fallback (so it ends up using a fallback that still
> does not support the P-192 curve).
>
> Also, the implementation without fallback is still failing crypto self-
> tests (as expected I guess).
>
> Therefore, I tried with a slightly different solution. Still two
> implementations, but with different cra_names (one with cra_name =
> "ecdh" and the other one with cra_name = "ecdh-keembay"). This solution
> seems to be working, since, the "ecdh-keembay" is not tested by the
> self tests and is not picked up as fallback for "ecdh" (since, if I
> understand it correctly, it's like if I'm defining a new kind of kpp
> algorithm), but it's still picked when calling crypto_alloc_kpp("ecdh-
> keembay").
>
> Does this second solution looks okay to you? Or does it have some
> pitfall that I'm missing?
>

You should set the CRYPTO_ALG_NEED_FALLBACK flag on both
implementations, to ensure that neither of them are considered as
fallbacks themselves.
