From: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Mon, 16 Apr 2007 10:37:01 +0200
Message-ID: <38b2ab8a0704160137g1ef0713fl943c51ed9049212b@mail.gmail.com>
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
	 <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704141410q65f55381w26527aeb10fb4988@mail.gmail.com>
	 <20070415075201.GA1644@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.228]:65018 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965180AbXDPIhD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Apr 2007 04:37:03 -0400
Received: by nz-out-0506.google.com with SMTP id s1so1149936nze
        for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 01:37:03 -0700 (PDT)
In-Reply-To: <20070415075201.GA1644@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4/15/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sat, Apr 14, 2007 at 11:10:08PM +0200, Francis Moreau wrote:
> >
> > ok but do you think it's safe to assume that no others parts of the
> > kernel will request "aes-foo" ? Remember that the main point is to
> > optimize "aes-foo" ?
>
> What they request is up to the administrator.
>

But do you think it's safe to design aes driver that could work only
with one kernel user and to rely on administrator config to verify
this condition ?

BTW, here are figures I got with 2 different versions of the driver
when using tcrypt module. The second being the result with the
optimized driver (no key reloading on each block):

normal version:
test 4 (128 bit key, 8192 byte blocks): 1 operation in 67991 cycles (8192 bytes)

optimized version:
test 4 (128 bit key, 8192 byte blocks): 1 operation in 51783 cycles (8192 bytes)

So the gain is 16000 cycles which seems to worth the change, isn't it ?

thanks
-- 
Francis
