From: Chris Umphress <umphress@gmail.com>
Subject: Re: pcomp for lzma for later use with squashfs
Date: Fri, 8 May 2009 13:00:06 -0500
Message-ID: <1f29b8940905081100i37bfe435rad2d50230cae8161@mail.gmail.com>
References: <4A041EE5.4000008@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	linux-crypto@vger.kernel.org, phillip@lougher.demon.co.uk
To: Karl Hiramoto <karl@hiramoto.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:56168 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbZEHSAJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 May 2009 14:00:09 -0400
Received: by ey-out-2122.google.com with SMTP id 9so529079eyd.37
        for <linux-crypto@vger.kernel.org>; Fri, 08 May 2009 11:00:07 -0700 (PDT)
In-Reply-To: <4A041EE5.4000008@hiramoto.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 8, 2009 at 7:00 AM, Karl Hiramoto <karl@hiramoto.org> wrote:
> Hi Geert,
>
> Was wondering if there are any patches for pcomp lzma. it it just a matter
> of adding crypto/lzma to make the calls to lib/decompress_unlzma.c ?
>
> I just started looking at this, my end goal is to use your pcomp patch for
> squashfs and get lzma squahsfs.

I've just begun to look at this over the last couple days as well but
have not yet been able to assess what is necessary to make this
happen.

If you are interested in developing the patch, I'm willing to help.

-- 
Chris Umphress <http://www.epicvoyage.org>
