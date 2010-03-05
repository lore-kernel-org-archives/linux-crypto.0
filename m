From: Dimitrios Siganos <dimitris@siganos.org>
Subject: Re: hmac(sha1)
Date: Fri, 05 Mar 2010 16:17:16 +0000
Message-ID: <4B912E8C.4010009@siganos.org>
References: <20100305073204.GA3745@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lvps94-136-60-187.vps.webfusion.co.uk ([94.136.60.187]:45942
	"EHLO siganos.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab0CEQRS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Mar 2010 11:17:18 -0500
In-Reply-To: <20100305073204.GA3745@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> Dimitrios Siganos <dimitris@siganos.org> wrote:
>   
> Note that we don't currently have a working asynchronous hash
> driver so in a way you'll need to write things from scratch.
> However, we're all happy to assist you in this process.
>   
I am using linux 2.6.28, and in that version, the crc32 implementation 
is of type AHASH. According to git, crc32 was converted to SHASH on 25 
Dec 2008. I am basing my AHASH implementation on the crc32 AHASH.
