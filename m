Return-Path: <SRS0=zNYl=VI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4F4C74A35
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 11:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75302208E4
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 11:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="CfIfHB1r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfGKL7q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jul 2019 07:59:46 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:10903 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbfGKL7q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jul 2019 07:59:46 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jul 2019 07:59:45 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562846382;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=OuwZ8K0f/Gg0RtZtWjajCRJNHjGMsgFwRKm7HEm15Qc=;
        b=CfIfHB1rJMqMlyaCkkle+fM0C7apQMpe+2RbbXE0Fqzdf3buncb1gadzdbw9N2pfXK
        tNSqHP8r9FMDrYU+C7Dn4jmcwqKQj58y0MLEOb0EVzuB4CCL++Fb+MDYU/4TWcNBea7Z
        jJ+ptJTCZKE2y+HQLZRmON+5ndugZ5GMK9AbzriNuLU0/n5ALxU2X0GatzB+PEXy7lae
        PzERneUEgXdEGsUscSxhNTHfzqjbVMTzC0eI83K8QqjoOnyLLs41DZHiTVC9MB82w1GX
        OaXSHawJ+JZ2Nq4yRDg/AyX8sF6L0+Nz2UsI+MGRSJ3QeAZ2s6dOWn4gN1uGw6JmVvoF
        oDiw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xm0dNS3IdRcRALiq2+M="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id 9078d1v6BBxfwtR
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 11 Jul 2019 13:59:41 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: CAVS test harness
Date:   Thu, 11 Jul 2019 13:59:41 +0200
Message-ID: <1782078.ZURsmYODYl@tauon.chronox.de>
In-Reply-To: <3201120.NINpRaGeap@tauon.chronox.de>
References: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM> <3201120.NINpRaGeap@tauon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 11. Juli 2019, 13:52:29 CEST schrieb Stephan Mueller:

Hi,

> Am Dienstag, 9. Juli 2019, 08:43:51 CEST schrieb Bhat, Jayalakshmi
> Manjunath:
> 
> Hi Jayalakshmi,
> 
> > Hi All,
> > 
> > We are working on a product that requires NIAP certification and use IPSec
> > environment for certification. IPSec functionality is achieved by third
> > party IPsec library and native XFRM. Third  party IPsec library is used
> > for
> > ISAKMP and XFRM for IPsec.
> > 
> > CAVS test cases are required for NIAP certification.  Thus we need to
> > implement CAVS test harness for Third party library and Linux crypto
> > algorithms. I found the documentation on kernel crypto API usage.
> > 
> > Please can you indication what is the right method to implement the test
> > harness for Linux crypto algorithms.
> > 1.	Should I implement CAVS test
> > harness for Linux kernel crypto algorithms as a user space application
> > that
> > exercise the kernel crypto API?
> > 2.	Should I implement  CAVS test harness as
> > module in Linux kernel?
> 
> As I have implemented the full CAVS test framework I can tell you that the
> AF_ALG interface will not allow you to perform all tests required by CAVS.
> 
> Thus you need to implement your own kernel module with its own interface.

As a side note: if you only want to test the symmetric ciphers and the hashes/
HMACs, you can implement that with libkcapi easily.

However, if you are interested in testing the DRBG due to its relevance for 
the GCM IV, you certainly need a kernel module.
> 
> > Any information on this will help me very much on implementation.
> > 
> > Regards,
> > Jayalakshmi
> 
> Ciao
> Stephan



Ciao
Stephan


