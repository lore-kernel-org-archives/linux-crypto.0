From: "Gautam Singaraju" <gautam.singaraju@gmail.com>
Subject: Re: RSA support into kernel?
Date: Fri, 6 Jul 2007 10:23:34 -0700
Message-ID: <f8b2ccd40707061023o432f0072xd5a1c34ba4cd1013@mail.gmail.com>
References: <20070706.040533.30182871.davem@davemloft.net>
	 <E1I6ncC-0007e3-00@gondolin.me.apana.org.au>
	 <20070706133636.GH23191@halcrow.us>
	 <f8b2ccd40707060741o82b4d53va3881eae7450366@mail.gmail.com>
	 <20070706154117.GI23191@halcrow.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Michael Halcrow" <mike@halcrow.us>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.228]:51899 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbXGFRXf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jul 2007 13:23:35 -0400
Received: by nz-out-0506.google.com with SMTP id s18so265464nze
        for <linux-crypto@vger.kernel.org>; Fri, 06 Jul 2007 10:23:35 -0700 (PDT)
In-Reply-To: <20070706154117.GI23191@halcrow.us>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Ok, I see that there has been a previous attempt been made to support
bignum library, hence PKI, in kernel in a project named Cryptomark.
Thanks!

On 7/6/07, Michael Halcrow <mike@halcrow.us> wrote:
> On Fri, Jul 06, 2007 at 07:41:18AM -0700, Gautam Singaraju wrote:
> > I am considering RSA as an option for research purposes; though I
> > need it only for decryption purposes. Any specific reason for
> > running the daemon in user space?
>
> That's where RSA is.
>
> Mike
> .___________________________________________________________________.
>                          Michael A. Halcrow
>        Security Software Engineer, IBM Linux Technology Center
> GnuPG Fingerprint: 419C 5B1E 948A FA73 A54C  20F5 DB40 8531 6DCA 8769
>
> panic: kernel trap (ignored)
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (GNU/Linux)
>
> iQEVAwUBRo5inNtAhTFtyodpAQNlCQf8Ddk3dymDPMPoVDJHR78KcJ4eSZD0NbDV
> Lwlwp54262mYNAfALCrs/t/CcUaJOWl3Zr0zPkWehu73HEsvbUZqVV2swyrgIFZY
> kwELd/wA1ii5HJRhzZ9GcL9dJeUQb58aXoepZKmDcjTDjgXFYxSKWRm29h+zj9o0
> z/WwqF5Fzj/YDtTHaCJhSticRaeZvXpPkIjQy4JZoOt1nNagU0dPD7GxZpoRva1k
> 0EfRtV97xJEt3eYguBiAx9sb9ndJ5ndpYUZxI4a/NMhdO1s8w2T0fP2yfr6KX0YJ
> 5Io4itFZl3S5m9ZdmI8VAFHI13oJEtP/EuqC3VqaP8V4MdtS+MMsWA==
> =ckOc
> -----END PGP SIGNATURE-----
>
>


-- 
---
Gautam
