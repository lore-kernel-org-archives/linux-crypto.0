From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH v1 2/7] AES for PPC/SPE - aes tables
Date: Mon, 16 Feb 2015 08:37:06 -0600
Message-ID: <20150216143706.GA3609@gate.crashing.org>
References: <cfb098e9-69ae-47ff-afa7-08c922accd31@EXCHANGE.collogia.de> <063D6719AE5E284EB5DD2968C1650D6D1CAE46B2@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "'Markus Stockhausen'" <stockhausen@collogia.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: David Laight <David.Laight@ACULAB.COM>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:34514 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbbBPOiu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Feb 2015 09:38:50 -0500
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CAE46B2@AcuExch.aculab.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 16, 2015 at 02:19:50PM +0000, David Laight wrote:
> From:  Markus Stockhausen
> > 4K AES tables for big endian
> 
> I can't help feeling that you could give more information about how the
> values are generated.

... and an explanation of why this does not open you up to a timing attack?


Segher
