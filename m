From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 1/4] lib: hex2bin converts ascii hexadecimal string to binary
Date: Wed, 29 Sep 2010 13:11:03 +0100
Message-ID: <9444.1285762263@redhat.com>
References: <1285698993-16927-2-git-send-email-zohar@linux.vnet.ibm.com> <1285698993-16927-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab0I2MLJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Sep 2010 08:11:09 -0400
In-Reply-To: <1285698993-16927-2-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> @@ -34,6 +34,22 @@ int hex_to_bin(char ch)
>  EXPORT_SYMBOL(hex_to_bin);
>  
>  /**
> + * hex2bin - convert an ascii hexadecimal string to its binary representation
> + * @mem: result
> + * @buf: ascii hexadecimal string
> + * @count: result length
> + */
> +void hex2bin(unsigned char *mem, char *buf, int count)

Hmmm...  It might be better to put this in its own file in lib, otherwise it
will drag in all the other functions in that file if used, and vice versa.

David
