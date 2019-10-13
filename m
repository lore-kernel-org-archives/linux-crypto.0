Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1772DC4CECE
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 17:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3C952168B
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 17:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbfJMRoa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 13:44:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:59040 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726264AbfJMRoa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 13:44:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 83A5EAD87;
        Sun, 13 Oct 2019 17:44:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5486ADA7E3; Sun, 13 Oct 2019 19:44:41 +0200 (CEST)
Date:   Sun, 13 Oct 2019 19:44:41 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>, linux-crypto@vger.kernel.org,
        ard.biesheuvel@linaro.org
Subject: Re: [PATCH v4 1/5] crypto: add blake2b generic implementation
Message-ID: <20191013174441.GL2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
References: <cover.1570812094.git.dsterba@suse.com>
 <6494ffe9b7940efa4de569d9371da7b1623e726b.1570812094.git.dsterba@suse.com>
 <20191011180439.GB235973@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011180439.GB235973@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 11, 2019 at 11:04:40AM -0700, Eric Biggers wrote:
> > +struct blake2b_param
> > +{
> 
> It should be 'struct blake2b_param {'
> 
> checkpatch.pl should warn about this.  Can you fix the checkpatch warnings that
> make sense to fix?

I fixed all the { at the end of line of struct definitions and left all
of type

  ERROR: space prohibited after that open square bracket '['
  #276: FILE: crypto/blake2b_generic.c:200:
  +       v[ 9] = blake2b_IV[1];

and

  WARNING: line over 80 characters
  #304: FILE: crypto/blake2b_generic.c:228:
  +static void blake2b_update(struct blake2b_state *S, const void *pin, size_t inlen)

ie. where the ) or ); is beyond 80 but does not otherwise hurt
readability unlike forced newline and parameters on another line. This
is my prefrence in code I otherwise work on but I'll follow what's
common practice in crypto/.

> > +/* init xors IV with 
> > +static int blake2b_init_param(struct blake2b_state *S,
> > +			      const struct blake2b_param *P)
> > +{
> > +	const u8 *p = (const u8 *)(P);
> > +	size_t i;
> > +
> > +	blake2b_init0(S);
> > +
> > +	/* IV XOR ParamBlock */
> > +	for (i = 0; i < 8; ++i)
> > +		S->h[i] ^= get_unaligned_le64(p + sizeof(S->h[i]) * i);
> > +
> > +	S->outlen = P->digest_length;
> > +	return 0;
> > +}
> 
> No need for this to have a return value anymore.  Same with:
> 
> 	blake2b_init_param()
> 	blake2b_update()
> 	blake2b_init()
> 	blake2b_init_key()
> 	blake2b_final()
> 
> The code would be more readable if they returned void, since otherwise it gives
> the impression that errors can occur.

Make sense.

> > +static int blake2b_update(struct blake2b_state *S, const void *pin, size_t inlen)
> > +{
> > +	const unsigned char *in = (const unsigned char *)pin;
> 
> Convention is to use 'u8', not 'unsigned char'.

Fixed.

> > +MODULE_ALIAS_CRYPTO("blake2b");
> > +MODULE_ALIAS_CRYPTO("blake2b-generic");
> 
> Should remove these module aliases now that the "blake2b" algorithm was removed.

A bit more of typing 'modprobe blake2-512' but I have checked if other
modules use a bare algo name as an alias and found none. So for
consistency I'll remove the 2 lines.
