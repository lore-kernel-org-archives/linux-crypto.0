From: Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: SPHINX: no structured comments
Date: Sat, 15 Oct 2016 18:12:36 +0200
Message-ID: <D10CA7D8-CE8A-4C32-BDA8-1641D166649C@darmarit.de>
References: <1730886.FCUxIFiraa@positron.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1730886.FCUxIFiraa@positron.chronox.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Am 15.10.2016 um 17:05 schrieb Stephan Mueller <smueller@chronox.de>:

> Hi,
> 
> I am converting the kernel crypto API DocBook into Sphinx. The conversion is 
> complete, but I am having difficulties finding the cause for the following 
> notification obtained during the Sphinx compilation:
> 
> ./include/linux/crypto.h:1: warning: no structured comments found
> 
> I am unsure what is wrong in line 1 of the mentioned header.
> 
> Thanks a lot
> Stephan

Hi Stephan,

I suppose you have a typo in one of your kernel-doc
directives. E.g.::

 .. kernel-doc:: include/linux/crypto.h
     :functions: fooTypo

will produce those error messages:

 $ ./scripts/kernel-doc -function fooTypo  -rst ./include/linux/crypto.h
 ./include/linux/crypto.h:1: warning: no structured comments found

hope that helps.

FYI:

IMO the kernel-doc parser in the kernel sources is lazy.  In my
linuxdoc project you will find a more enthusiastic one with a
lint command.

 https://return42.github.io/linuxdoc

Even if this kernel-doc parser is not (yet) a part of the kernel
source tree, the kernel-lintdoc command might be helpful
finding (more) issues

 https://return42.github.io/linuxdoc/cmd-line.html#kernel-lintdoc

The installation is quite simple:

 pip install git+http://github.com/return42/linuxdoc.git

The next hint might be a bit to late for you, but there is a
*automatic* DocBook to reST migration of the crypto API:

 https://github.com/return42/sphkerneldoc/tree/master/doc/Documentation/books_migrated/crypto-API

This migration is done with the my dbxm2rst project:

 https://return42.github.io/dbxml2rst/

If you need more help or want to migrate more DocBook
documentation to reST ... don't hesitate to contact me
(on the ML or directly / de-de ;-)

-- Markus --

