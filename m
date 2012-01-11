From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: Re: sha512: make it work, undo percpu message schedule
Date: Wed, 11 Jan 2012 02:12:48 +0100
Message-ID: <4F0CE210.1080305@codelabs.ch>
References: <20120111000040.GA3801@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.codelabs.ch ([217.150.249.120]:33648 "EHLO
	fenrir.codelabs.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab2AKBSd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jan 2012 20:18:33 -0500
In-Reply-To: <20120111000040.GA3801@p183.telecom.by>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/11/2012 01:00 AM, Alexey Dobriyan wrote:
> commit f9e2bca6c22d75a289a349f869701214d63b5060
> aka "crypto: sha512 - Move message schedule W[80] to static percpu area"
> created global message schedule area.

[snip]

> I personally don't understand this changelog entry:
> 
> 	"The message schedule W (u64[80]) is too big for the stack."
> 
> Hash context is dynamically allocated.

My original patch did the same thing as yours and put the message
schedule on the stack in sha512_transform. Herbert argued [1], that it
was too big and suggested to store it in a static per-cpu area.

[1] - http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg02527.html
