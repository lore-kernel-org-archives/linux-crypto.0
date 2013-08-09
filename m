From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: Re: Questions about the Crypto API
Date: Fri, 9 Aug 2013 09:55:14 -0300
Message-ID: <20130809125513.GA7674@oc8526070481.ibm.com>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <065BBB7616BCE543832A2EF096986B940A05ADCD@039-SN2MPN1-011.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:53748 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3HIMzV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Aug 2013 08:55:21 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Fri, 9 Aug 2013 09:55:18 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 5557E352005F
	for <linux-crypto@vger.kernel.org>; Fri,  9 Aug 2013 08:55:17 -0400 (EDT)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
	by d24relay01.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r79Corjf1065196
	for <linux-crypto@vger.kernel.org>; Fri, 9 Aug 2013 09:50:53 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
	by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r79CtGmg004181
	for <linux-crypto@vger.kernel.org>; Fri, 9 Aug 2013 09:55:16 -0300
Content-Disposition: inline
In-Reply-To: <065BBB7616BCE543832A2EF096986B940A05ADCD@039-SN2MPN1-011.039d.mgd.msft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 08, 2013 at 02:50:41PM +0000, Garg Vakul-B16394 wrote:
> Hi Herbert
> 
> 
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> > owner@vger.kernel.org] On Behalf Of Herbert Xu
> > Sent: Tuesday, August 06, 2013 12:30 PM
> > To: Marcelo Cerri
> > Cc: linux-crypto@vger.kernel.org
> > Subject: Re: Questions about the Crypto API
> > 
> > On Mon, Aug 05, 2013 at 05:25:57PM -0300, Marcelo Cerri wrote:
> > >
> > > My first doubt is regarding which kind of concurrency the Crypto API
> > > allows. For example, can a single `struct crypto_tfm` be used by two
> > > concurrent calls? I'm asking about that because I noticed that for
> > 
> > Yes.
> > 
> 
> In this post, you mentioned that tfm is single threaded.
> Am I misinterpreting your statement?
> 
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg08689.html
> 

Hi Herbert,

I also would like to better understand that. It doesn't seem natural for
me that a single tfm can be used by multiple kernel threads.

Best regards,
Marcelo
