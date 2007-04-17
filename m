From: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 16:41:00 +0200
Message-ID: <38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	 <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.229]:60721 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbXDQOlB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 10:41:01 -0400
Received: by nz-out-0506.google.com with SMTP id s1so1496983nze
        for <linux-crypto@vger.kernel.org>; Tue, 17 Apr 2007 07:41:01 -0700 (PDT)
In-Reply-To: <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Francis Moreau <francis.moro@gmail.com> wrote:
> > On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >>
> >> Actually, I was referring to your AES module :)
> >
> > Well I don't if I can do that unfortunately.
>
> What's the problem?
>

Always the same problem. Some stupid people here think that they have
designed the most wonderful AES hardware module. If I give you the
code of the driver I'll show you a lot of "confidential" stuff.

> > Actually there's nothing really interesting in this code, only key or
> > acc loadings and that's it.
> >
> > What do you want to see exactly ?
>
> Well if your code's faster than what we have in the kernel then we
> should use yours instead.
>

Again, my code is faster only because I skip the key loading in
"cia_encrypt" method. Actually the gain is bigger in decryption mode
than in encryption one because I also generate the decryption key for
each block.

You see there's absolutely no clever trick here...
-- 
Francis
