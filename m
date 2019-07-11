Return-Path: <SRS0=zNYl=VI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A23C74A52
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 12:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD691208E4
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 12:00:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Y9zNsnLf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfGKMAH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jul 2019 08:00:07 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:15462 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728578AbfGKMAH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jul 2019 08:00:07 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jul 2019 08:00:06 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562846405;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=FYeHa/LQBgNc1fXBsPNk0LV3l5dXWty8yWc+ydNtiKs=;
        b=Y9zNsnLfuCVgwIimRHQa+YyfobVsWuBepdqJSq5O/fYzoQ+1FXqf5Og/Nh5OTx/nb9
        HJN89Ha6EVuwiPPKpxQZgHy2hznKnya5LT4dKBa6zaZe4/xK6my7q9dCyWUupaOBZNMO
        +zsQpWQB8p8i/GKDzr93u5NjtQIoj9F3xmtahY/V6lBlAW5/0195tzn6W/zNk0YVm+sh
        HVEet4YNbFPnEXCOWyVpqjtzySzDskaQabmCQ4kkWgw1uR/NejVzwaNMgDgrYF/7hcGG
        lBZpEL3xXVMxiDk52/lPlZlUdUjID5oSlVXygFcU28pEBhAyar5TM8UuQ5UZ1B+FqQi7
        UeXA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3IdRcRALiq2+M="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id 9078d1v6BBs5wqk
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 11 Jul 2019 13:54:05 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: CAVS test harness
Date:   Thu, 11 Jul 2019 13:54:05 +0200
Message-ID: <2656048.2Ru0tYgSs3@tauon.chronox.de>
In-Reply-To: <CAOtvUMcUeVYh_eUrQWqunR8NUpos5-7zRU0jn0RdSTMtikm0XQ@mail.gmail.com>
References: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM> <CAOtvUMcUeVYh_eUrQWqunR8NUpos5-7zRU0jn0RdSTMtikm0XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 9. Juli 2019, 13:34:21 CEST schrieb Gilad Ben-Yossef:

Hi Gilad,

> On Tue, Jul 9, 2019 at 9:44 AM Bhat, Jayalakshmi Manjunath
> 
> <jayalakshmi.bhat@hp.com> wrote:
> > Hi All,
> > 
> > We are working on a product that requires NIAP certification and use IPSec
> > environment for certification. IPSec functionality is achieved by third
> > party IPsec library and native XFRM. Third  party IPsec library is used
> > for ISAKMP and XFRM for IPsec.
> > 
> > CAVS test cases are required for NIAP certification.  Thus we need to
> > implement CAVS test harness for Third party library and Linux crypto
> > algorithms. I found the documentation on kernel crypto API usage.
> > 
> > Please can you indication what is the right method to implement the test
> > harness for Linux crypto algorithms. 1.      Should I implement CAVS test
> > harness for Linux kernel crypto algorithms as a user space application
> > that exercise the kernel crypto API? 2.      Should I implement  CAVS
> > test harness as module in Linux kernel?
> > 
> > 
> > Any information on this will help me very much on implementation.
> 
> Are you sure the needed tests are not already implemented in the
> kernel crypto API testmgr?

The testmgr implements the power-on self tests required by FIPS 140-2. But 
CAVS testing implies that there is a large set of test vectors which need to 
be processed by the crypto implementations.

These test vectors are generated anew for each test round. Only the test 
approach remains stable.
> 
> Gilad



Ciao
Stephan


