From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 0/8] Conversion crypto API documentation to Sphinx
Date: Sun, 23 Oct 2016 10:32:38 -0600
Message-ID: <20161023103238.4fceddac@lwn.net>
References: <2053893.WjF01BJSDF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2053893.WjF01BJSDF@positron.chronox.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 21 Oct 2016 04:53:45 +0200
Stephan Mueller <smueller@chronox.de> wrote:

> the attached patch set converts the existing crypto API documentation
> from DocBook to Sphinx.

This looks generally good to me - thanks for doing it!

Is there any chance of running the Documentation/ parts through the docs
tree?  Documentation/index.rst has become a bit of a conflict point
otherwise...

Thanks,

jon
