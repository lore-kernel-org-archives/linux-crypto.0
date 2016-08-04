From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] DH support: add KDF handling support
Date: Thu, 04 Aug 2016 20:45:34 +0200
Message-ID: <6128256.7t5iWuU9Dv@positron.chronox.de>
References: <2239809.KsND40bFeW@positron.chronox.de> <2313703.12yUpncF2W@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34006 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934165AbcHDSws (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 14:52:48 -0400
In-Reply-To: <2313703.12yUpncF2W@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 4. August 2016, 20:38:59 CEST schrieb Stephan Mueller:

Hi Mat,

> @@ -1663,6 +1668,7 @@ static void act_keyctl_dh_compute(int argc, char
> *argv[]) }
> 
>  		printf("%02hhx", *p);
> +		*p = 0x00;	/* zeroize buffer */
>  		p++;
> 
>  		col++;
> @@ -1674,6 +1680,125 @@ static void act_keyctl_dh_compute(int argc, char
> *argv[]) } while (--ret > 0);
> 
>  	printf("\n");
> +
> +	free(buffer);


I hope it is ok that I add a bugfix in that patch set.

Ciao
Stephan
