From: Andreas Ziegler <andreas.ziegler@fau.de>
Subject: Left-over select to PUBLIC_KEY_ALGO_RSA
Date: Fri, 4 Mar 2016 16:17:16 +0100
Message-ID: <56D9A6FC.7000307@fau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Valentin Rothberg <valentinrothberg@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi David,

your patch "akcipher: Move the RSA DER encoding check to the crypto
layer" showed up in linux-next today as commit d43de6c780a8 (that is,
next-20160304).

It removes the CONFIG_PUBLIC_KEY_ALGO_RSA option, but does leave one
reference to it in place inside security/integrity/Kconfig, in the
definition of CONFIG_INTEGRITY_ASYMMETRIC_KEYS.

As the corresponding option is gone, the select statement can safely be
removed. Should I prepare a simple patch for that?

I detected this by using scripts/checkkconfigsymbols on today's and
yesterday's linux-next trees (i.e., "./scripts/checkkconfigsymbols.py -d
next-20160303..next-20160304").

Best regards,

Andreas
