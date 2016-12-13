From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2 0/8] Conversion crypto API documentation to Sphinx
Date: Tue, 13 Dec 2016 23:06:14 +0100
Message-ID: <3555336.Wm4L5bpP9y@positron.chronox.de>
References: <2053893.WjF01BJSDF@positron.chronox.de> <2168354.PkToFvufzV@positron.chronox.de> <20161213145059.5204d498@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20161213145059.5204d498@lwn.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 13. Dezember 2016, 14:50:59 CET schrieb Jonathan Corbet:

Hi Jonathan,

> On Tue, 13 Dec 2016 22:25:07 +0100
> 
> Stephan Müller <smueller@chronox.de> wrote:
> > Considering that a large batch of documentation updates just landed in
> > Linus' tree, I am wondering why the crypto API documentation update is
> > not among it.
> Well, I'd asked if I could run the documentation-specific parts through
> docs-next.  I guess I was waiting for a version of the patch set with just
> that, rather than intermixed with a bunch of crypto-side changes.  Were
> you expecting me to take the whole set?
> 
> I can still try to do that, I guess; let me know if I should try to set
> the whole set upward.
> 

I am sorry, then I may have misunderstood you.

I would think that Herbert agreed that you push the entire patch set through 
your tree, including the documentation changes to the crypto header files.

I just did a patch on the parts that touch the crypto header files. All apply 
cleanly except patch 07/08 which has a 5 line hunk due to other changes, Is 
that hunk ok for you, it would be great if you could take it. If you do not 
like that hunk, we could push it through the cryptodev tree once rc-1 is out.

Thanks a lot.

Ciao
Stephan
