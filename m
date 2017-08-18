From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH] crypto: ccp - Fix XTS-AES-128 support on v5 CCPs
Date: Fri, 18 Aug 2017 11:41:04 -0500
Message-ID: <32d0b50e-e5d5-6041-0ee9-f8384c7c79a3@amd.com>
References: <150032210775.102848.1585950131204303137.stgit@sosxen.amd.com>
 <14a02623-b19e-b4ae-c078-57912a83cd4b@amd.com>
 <f5714d71-4e4a-b942-7e1e-58f478a5ff21@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0057.outbound.protection.outlook.com ([104.47.33.57]:33712
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751558AbdHRQlK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2017 12:41:10 -0400
In-Reply-To: <f5714d71-4e4a-b942-7e1e-58f478a5ff21@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>On Tue, Jul 25, 2017 at 02:12:11PM -0500, Gary R Hook wrote:
> > Version 5 CCPs have some new requirements for XTS-AES: the type field
> > must be specified, and the key requires 512 bits, with each part
> > occupying 256 bits and padded with zeroes.
> >
> > cc: <stable@vger.kernel.org> # 4.9.x+
> >
> > Signed-off-by: Gary R Hook <ghook@amd.com>
>
> Patch applied.  Thanks.

Herbert,

*ping*

This is a bug fix, Could we push this into 4.13, please?

Gary
