From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 12/12] crypto: caam - add Run Time Library (RTA) docbook
Date: Tue, 19 Aug 2014 13:54:50 -0700
Message-ID: <53F3B99A.2020002@infradead.org>
References: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com> <1408020874-2211-13-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42074 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaHSUy5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Aug 2014 16:54:57 -0400
In-Reply-To: <1408020874-2211-13-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/14/14 05:54, Horia Geanta wrote:
> Add SGML template for generating RTA docbook.
> Source code is in drivers/crypto/caam/flib
> 
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> ---
>  Documentation/DocBook/Makefile         |   3 +-
>  Documentation/DocBook/rta-api.tmpl     | 261 ++++++++++++++++++++++
>  Documentation/DocBook/rta/.gitignore   |   1 +
>  Documentation/DocBook/rta/Makefile     |   5 +
>  Documentation/DocBook/rta/rta_arch.svg | 381 +++++++++++++++++++++++++++++++++
>  5 files changed, 650 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/DocBook/rta-api.tmpl
>  create mode 100644 Documentation/DocBook/rta/.gitignore
>  create mode 100644 Documentation/DocBook/rta/Makefile
>  create mode 100644 Documentation/DocBook/rta/rta_arch.svg

> diff --git a/Documentation/DocBook/rta-api.tmpl b/Documentation/DocBook/rta-api.tmpl
> new file mode 100644
> index 000000000000..90c5c5a8d9a7
> --- /dev/null
> +++ b/Documentation/DocBook/rta-api.tmpl
> @@ -0,0 +1,261 @@
> +<?xml version="1.0" encoding="UTF-8"?>
> +<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
> +        "http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
> +
> +<book id="RTAapi">
> + <bookinfo>
> +  <title>Writing descriptors for Freescale CAAM using RTA library</title>
> +  <authorgroup>
> +   <author>
> +    <firstname>Horia</firstname>
> +    <surname>Geanta</surname>
> +    <affiliation>
> +     <address><email>horia.geanta@freescale.com</email></address>
> +    </affiliation>
> +   </author>
> +  </authorgroup>
> +
> +  <copyright>
> +   <year>2008-2014</year>
> +   <holder>Freescale Semiconductor</holder>
> +  </copyright>
...
> +  <chapter id="intro">
> +    <title>Introduction</title>
> +    <sect1>
> +      <title>About</title>
> +!Pdrivers/crypto/caam/flib/rta.h About
> +!Pdrivers/crypto/caam/flib/rta.h Usage
> +      <mediaobject>
> +        <imageobject>
> +          <imagedata fileref="rta_arch.svg" format="SVG" align="CENTER"/>
> +        </imageobject>
> +        <caption><para>RTA Integration Overview</para></caption>
> +      </mediaobject>
> +    </sect1>
> +    <sect1>
> +      <title>Using RTA</title>
> +      <para>
> +        RTA can be used in an application just by including the following header file:
> +	#include flib/rta.h

Needs quotation marks or angle brackets?

> +      </para>
> +      <para>
> +        The files in drivers/crypto/caam/desc directory contain several
> +	real-world descriptors written with RTA. You can use them as-is or adapt
> +	them to your needs.
> +      </para>
> +      <para>
> +        RTA routines take as first parameter a pointer to a "struct program"
> +        variable. It contains several housekeeping information that are used

       drop:                     several         &      change:        is

> +        during descriptor creation.
> +      </para>
> +      <para>
> +        RTA creates the descriptors and saves them in buffers. It is the user's
> +	job to allocate memory for these buffers before passing them to RTA
> +	program initialization call.
> +      </para>
> +      <para>
> +        A RTA program must start with a call to PROGRAM_CNTXT_INIT and end with

           An

> +	PROGRAM_FINALIZE. PROGRAM_CNTXT_INIT will initialze the members of

                                                  initialize

> +	'program' structure with user information (pointer to user's buffer, and
> +	the SEC subversion). The PROGRAM_FINALIZE call checks the descriptor's
> +	validity.
> +      </para>

[snip]


-- 
~Randy
