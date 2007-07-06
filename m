From: "Gautam Singaraju" <gautam.singaraju@gmail.com>
Subject: Re: RSA support into kernel?
Date: Fri, 6 Jul 2007 07:41:18 -0700
Message-ID: <f8b2ccd40707060741o82b4d53va3881eae7450366@mail.gmail.com>
References: <20070706.040533.30182871.davem@davemloft.net>
	 <E1I6ncC-0007e3-00@gondolin.me.apana.org.au>
	 <20070706133636.GH23191@halcrow.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>, johnpol@2ka.mipt.ru,
	linux-crypto@vger.kernel.org
To: "Michael Halcrow" <mike@halcrow.us>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.228]:23872 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490AbXGFOlT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jul 2007 10:41:19 -0400
Received: by nz-out-0506.google.com with SMTP id s18so219677nze
        for <linux-crypto@vger.kernel.org>; Fri, 06 Jul 2007 07:41:19 -0700 (PDT)
In-Reply-To: <20070706133636.GH23191@halcrow.us>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I am considering RSA as an option for research purposes; though I need
it only for decryption purposes. Any specific reason for running the
daemon in user space?

Gautam
On 7/6/07, Michael Halcrow <mike@halcrow.us> wrote:
> On Fri, Jul 06, 2007 at 09:12:52PM +0800, Herbert Xu wrote:
> > So far the only proposed user for RSA in-kernel seems to be module
> > signing and I'm staying well away from that debate :)
>
> eCryptfs uses RSA.
>
> Right now it has to defer to a userspace daemon to perform the
> operation.
>
> Mike
> .___________________________________________________________________.
>                          Michael A. Halcrow
>        Security Software Engineer, IBM Linux Technology Center
> GnuPG Fingerprint: 419C 5B1E 948A FA73 A54C  20F5 DB40 8531 6DCA 8769
>
> "This is about humans being human."
>  - Carl Sagan
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (GNU/Linux)
>
> iQEVAwUBRo5FZNtAhTFtyodpAQO9jAgAmCPiGap1u/Qd5Zogb/hxtpoNF8/7Vx+z
> FWnIbzI9jK8g1PBxXGkYVASQ/rPbT/yhX3Zg53jrJm+8RqDAQDY/Ca1qAUvDtD57
> R5Mo/eSSlwuvAMVsLFDYYINeER3fpIX7wdrwB5VTN6YKz9eJFhsNqMUSQ8mCSbbV
> qEzFUq8EdcYsaxSZ56uIXSSphneKXIDAzWCu5hjbLtr71WSkvXKe4kVZKElb1LrB
> SGxxPajTCnjuw1z9VL5Tp2pOfyX3pWRSnoiCxUjwl2Aco0hu+Nl+0X2qsVkkmBSx
> 0MoeTrZ+FAY0QBDlPbtR6N5kD4NvV94WXnfQPi5DC66730nwLufk4Q==
> =4vHb
> -----END PGP SIGNATURE-----
>
>


-- 
---
Gautam
