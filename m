From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] crypto: squash lines for simple wrapper functions
Date: Mon, 12 Sep 2016 12:44:17 -0700
Message-ID: <1473709457.11006.31.camel@perches.com>
References: <1473708474-32359-1-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
To: Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473708474-32359-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2016-09-13 at 04:27 +0900, Masahiro Yamada wrote:
> Remove unneeded variables and assignments.

Was this found by visual inspection or some tool?

If it's via a tool, it's good to mention that in the changelog.
