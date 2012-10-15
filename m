From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PULL] modules
Date: Mon, 15 Oct 2012 19:46:40 +1030
Message-ID: <87mwzo3xjb.fsf@rustcorp.com.au>
References: <87fw5m7ipz.fsf@rustcorp.com.au> <CA+55aFyGuy8P4Uaanmv7DncjsN6cvQxvWrrMKKnF=67J+BkshQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>,
	Alex Lyashkov <umka@cloudlinux.com>,
	Arnd Bergmann <arnd@arndb.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Josh Boyer <jwboyer@redhat.com>, linux-crypto@vger.kernel.org,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Milan Broz <mbroz@redhat.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:46887 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2JOLso (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Oct 2012 07:48:44 -0400
In-Reply-To: <CA+55aFyGuy8P4Uaanmv7DncjsN6cvQxvWrrMKKnF=67J+BkshQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Oct 10, 2012 at 2:57 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> ----------------------------------------------------------------
>> module signing is the highlight, but it's an all-over David Howells frenzy...
>>
>> ----------------------------------------------------------------
>
> Hmm. What happened here? It *looks* from your pull request like you
> had a tag, and you usually do, but there's no tag anywhere..
>
> I've pulled and resolved the branch, and I'm going through it now, but
> I'd like this verified before I push out if it all looks fine..
>
>           Linus

Ah, I missed pushing the tag.  I used to fabricate a git tree for you
from my quilt series, and that script did the right thing.

Thanks,
Rusty.
