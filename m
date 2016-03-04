From: David Howells <dhowells@redhat.com>
Subject: Re: Left-over select to PUBLIC_KEY_ALGO_RSA
Date: Fri, 04 Mar 2016 15:23:49 +0000
Message-ID: <18370.1457105029@warthog.procyon.org.uk>
References: <56D9A6FC.7000307@fau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Valentin Rothberg <valentinrothberg@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
To: Andreas Ziegler <andreas.ziegler@fau.de>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <56D9A6FC.7000307@fau.de>
Content-ID: <18369.1457105029.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Andreas Ziegler <andreas.ziegler@fau.de> wrote:

> As the corresponding option is gone, the select statement can safely be
> removed. Should I prepare a simple patch for that?

Please.

> I detected this by using scripts/checkkconfigsymbols on today's and
> yesterday's linux-next trees (i.e., "./scripts/checkkconfigsymbols.py -d
> next-20160303..next-20160304").

Interesting - I didn't realise that exists.  This sort of consistency check
should be run every time the Kconfig files are parsed.

Thanks,
David
