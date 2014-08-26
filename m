From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Aug 26 (drbg)
Date: Tue, 26 Aug 2014 12:03:31 -0700
Message-ID: <53FCDA03.3050504@infradead.org>
References: <20140826173452.7cc5445c@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140826173452.7cc5445c@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 08/26/14 00:34, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140825:
> 
> The net tree gained a build failure for which I reverted a commit.
> 
> The mfd tree still had its build failure so I used the version from
> next-20140822.
> 

on i386:

../include/crypto/drbg.h:157:2: warning: left shift count >= width of type [enabled by default]
../include/crypto/drbg.h:163:2: warning: left shift count >= width of type [enabled by default]

I guess that someone has already seen this but I haven't noticed any reports
of it.


-- 
~Randy
