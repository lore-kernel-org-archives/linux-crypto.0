From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PULL] modules
Date: Sun, 14 Oct 2012 22:27:54 +0100
Message-ID: <20121014222754.0f11b609@pyramind.ukuu.org.uk>
References: <87fw5m7ipz.fsf@rustcorp.com.au>
	<CA+55aFyGuy8P4Uaanmv7DncjsN6cvQxvWrrMKKnF=67J+BkshQ@mail.gmail.com>
	<CA+55aFyVcTT4tKTVvhzXz3t4uw=MDLU00NAAOacWt6i3xovERg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	LKML <linux-kernel@vger.kernel.org>,
	Alex Lyashkov <umka@cloudlinux.com>,
	Arnd Bergmann <arnd@arndb.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Josh Boyer <jwboyer@redhat.com>, linux-crypto@vger.kernel.org,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Milan Broz <mbroz@redhat.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38894 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2JNVXw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Oct 2012 17:23:52 -0400
In-Reply-To: <CA+55aFyVcTT4tKTVvhzXz3t4uw=MDLU00NAAOacWt6i3xovERg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I realize that fips_enabled is only for crazy people, but it's exactly
> code like this that limits it to only crazy people. Is there some
> *reason* for this?

Presumably its so a typical server with reboot on panic will reboot so
the attacker can hide the attempt better ;-)

Alan
