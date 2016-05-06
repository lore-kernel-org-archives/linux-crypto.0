From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: UB in general ... and linux/bitops.h in particular
Date: Thu, 5 May 2016 22:25:16 -0400
Message-ID: <CAH8yC8kmo-m1roQT2PjavVp=cN=L5BcbVn+nZo6HM8-Jn90Ydg@mail.gmail.com>
References: <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
	<BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
	<20160504190723.GD3901@thunk.org>
	<572A6CDD.10503@av8n.com>
	<572A6F1C.2080708@av8n.com>
	<CAH8yC8kZDfw+6Ctog-C7Jb57rLnagAFMNwNfGH_dwa9fs=5h1Q@mail.gmail.com>
	<28624BFC-7C63-4F38-9F67-7CBFB0C6499B@zytor.com>
	<CAH8yC8ndyLipAdu5=vmyJ3eHYBS-mxQsRF2q2G2EuOfQxTpM7g@mail.gmail.com>
	<0015E1DE-DFF9-4CCE-805E-7AC286021BED@zytor.com>
	<CAH8yC8mbW5yTwbKN7_RMNVnTiKmtP0u3_2+tKV=-L4BZ6miGVw@mail.gmail.com>
	<20160505035028.GD10776@thunk.org>
	<CAH8yC8n974Z=mvXPsLiZqYPkVjBqtR=nqYQ-jJo194ECmWkofA@mail.gmail.com>
	<572AE9A2.20609@zytor.com>
	<572B71A7.1020100@av8n.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
To: John Denker <jsd@av8n.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36753 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbcEFCZR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 22:25:17 -0400
In-Reply-To: <572B71A7.1020100@av8n.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>    -- Perhaps the compiler guys could be persuaded to support
>     the needed features explicitly, perhaps via a command-line
>     option: -std=vanilla
>     This should be a no-cost option as things stand today, but
>     it helps to prevent nasty surprises in the future.

It looks LLVM has the -rainbow option; see
http://blog.llvm.org/2016/04/undefined-behavior-is-magic.html :)

Jeff
