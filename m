From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: Crypto causes panic in scatterwalk_done with large/multiple
 buffers
Date: Sat, 17 Nov 2012 10:39:01 +0200
Message-ID: <20121117103901.664145ijlv5r29wk@www.dalek.fi>
References: <50A4AFEE.9030206@lundman.net>
 <20121117024220.12381ph1ph0fu3q8@www.dalek.fi>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Jorgen Lundman <lundman@lundman.net>, linux-crypto@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:50640 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab2KQIjE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Nov 2012 03:39:04 -0500
In-Reply-To: <20121117024220.12381ph1ph0fu3q8@www.dalek.fi>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:

> Hello,
>
> I managed to reproduce something similiar with small buffers...
>
> Does attached patch help in your case?
>

Appearently this patch only fixed my debug printk loop that used  
sg_next from scatterlist API instead of scatterwalk_sg_next from  
scatterwalk API. Sorry for the noise.

-Jussi
