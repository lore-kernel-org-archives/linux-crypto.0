From: Stephan Mueller <smueller@chronox.de>
Subject: Re: SPHINX: no structured comments
Date: Sun, 16 Oct 2016 00:12:05 +0200
Message-ID: <16408240.aHQPdhiSNO@positron.chronox.de>
References: <1730886.FCUxIFiraa@positron.chronox.de> <D10CA7D8-CE8A-4C32-BDA8-1641D166649C@darmarit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org
To: Markus Heiser <markus.heiser@darmarit.de>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <D10CA7D8-CE8A-4C32-BDA8-1641D166649C@darmarit.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Samstag, 15. Oktober 2016, 18:12:36 CEST schrieb Markus Heiser:

Hi Markus,

> I suppose you have a typo in one of your kernel-doc
> directives. E.g.::
> 
>  .. kernel-doc:: include/linux/crypto.h
> 
>      :functions: fooTypo
> 
> will produce those error messages:
> 
>  $ ./scripts/kernel-doc -function fooTypo  -rst ./include/linux/crypto.h
>  ./include/linux/crypto.h:1: warning: no structured comments found
> 
> hope that helps.

Thanks for the hint. The issue was a removed API call.

...
> 
> The next hint might be a bit to late for you, but there is a
> *automatic* DocBook to reST migration of the crypto API:
> 
>  https://github.com/return42/sphkerneldoc/tree/master/doc/Documentation/book
> s_migrated/crypto-API

Thanks for the hint. You are right, it is a bit late, but the DocBook to 
Sphinx converter helped me.

With Sphinx now, I also split up the document into more manageable chunks and 
fixed some small issues.

Thanks for your help.

Ciao
Stephan
