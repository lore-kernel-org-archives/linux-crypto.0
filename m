From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: algif - Mark sgl end at the end of data
Date: Tue, 02 Dec 2014 07:06:40 -0800
Message-ID: <547DD580.4030900@intel.com>
References: <20141128184036.11421.36028.stgit@tstruk-mobl1> <20141201144026.GA18008@gondor.apana.org.au> <547C80F5.6000006@intel.com> <20141201150010.GA18277@gondor.apana.org.au> <547C8324.4000801@intel.com> <20141202143330.GA26049@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbaLBPJm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 10:09:42 -0500
In-Reply-To: <20141202143330.GA26049@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
On 12/02/2014 06:33 AM, Herbert Xu wrote:
> I think marking the end is useful.  How about doing the marking
> and unmarking whenever sgl->cur is updated?

I have a v2 ready where I mark it based on the actual data.
Thanks
