From: Richard Zidlicky <rz@linux-m68k.org>
Subject: Re: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Mon, 18 Jan 2010 20:51:22 +0100
Message-ID: <20100118195122.GA11762@linux-m68k.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-2-git-send-email-max@hinterhof.net> <4B390907.8010609@redhat.com> <20091229014639.GC26723@chaos.nusquama.org> <20100104152542.GA5388@quark.vpn.nusquama.org> <20100111212839.GA29008@linux-m68k.org> <20100113172715.GA29443@quark.vpn.nusquama.org> <20100117220234.GB25292@linux-m68k.org> <20100118170858.GE3964@quark.vpn.nusquama.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>, linux-crypto@vger.kernel.org,
	linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>,
	Alasdair G Kergon <agk@redhat.com>
To: Max Vozeler <max@hinterhof.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34615 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0ARTuT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2010 14:50:19 -0500
Received: by fxm25 with SMTP id 25so841650fxm.21
        for <linux-crypto@vger.kernel.org>; Mon, 18 Jan 2010 11:50:17 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20100118170858.GE3964@quark.vpn.nusquama.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

> > ivseed = key_table[64] is nowhere declared. 
> 
> This is an implementation detail of Loop-AES, so I don't consider it 
> belonging to the description of the modes here. 

difficult to draw the line, but as it is something supplied as "external 
parameter" to the dm-crypt layer I think it is certainly worth mentioning 
where it comes from.

> > > +  The input IV supplied to lmk2 or lmk3 is expected to be the
> > > +  sector number in 64-bit little endian as supplied by the
> > > +  plain64 dm-crypt IV generator. It gets truncated to 56 bits
> > > +  with the most significant byte set to 0x80:
> > 
> > I believe preceding paragraoh can be completely omitted, is not easier to 
> > understand than the pseudocode.
> 
> OK. I'll drop the last sentence, the first one describing where the
> IV is expected to come from seems relevant.

actually the first sentence does not make any sense to me as it is now.
 
> > > +Mode multi-key-v2 (lmk2-plain64-multi:64):
> > > +
> > > +  key = keys[sectornum % 64]
> > > +
> > > +  encrypt:
> > > +    IV = MD5(plaintext[16..511] ||
> > > +             le64(truncated-sector-number) ||
> > > +             le32(format-magic))
> > 
> > no need to repeat the IV description here, could use the v2/v3IV in the pseudocode
> > bellow. 
> 
> I think repeating it makes it clearer which parts happen at 
> which time, so I'd leave this as is.

at the very least I would use v2IV etc like in the earlier description. But I think
the duplication can be avoided.

Richard
