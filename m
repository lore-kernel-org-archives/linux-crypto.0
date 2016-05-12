From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 5/8] KEYS: Provide software public key query function [ver 3]
Date: Thu, 12 May 2016 11:19:23 +0100
Message-ID: <25139.1463048363@warthog.procyon.org.uk>
References: <alpine.OSX.2.20.1605111624090.16566@mjmartin-mac01.local> <20160511142152.4743.14414.stgit@warthog.procyon.org.uk> <20160511142230.4743.12500.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbcELKT0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 May 2016 06:19:26 -0400
In-Reply-To: <alpine.OSX.2.20.1605111624090.16566@mjmartin-mac01.local>
Content-ID: <25138.1463048363.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:

> > +	len = crypto_akcipher_maxsize(tfm);
> > +	info->key_size = len * 8;
> > +	info->max_data_size = len;
> > +	info->max_sig_size = len;
> > +	info->max_enc_size = len;
> > +	info->max_dec_size = len;
> 
> If len > UINT16_MAX, should UINT16_MAX be reported as the max size? Similar
> question for len*8 and key_size.

key_size is 32 bits, but the other sizes are all 16 bits, so you would need a
524288-bit key to exceed their capacity.  I'm not sure that's likely anytime
soon, but should I just make all the sizes 32-bit anyway?

David
