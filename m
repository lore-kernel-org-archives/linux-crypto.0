From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 14/16] X.509: Add an ASN.1 decoder
Date: Fri, 14 Sep 2012 10:39:30 +0100
Message-ID: <20120914103930.1e16ad8b@pyramind.ukuu.org.uk>
References: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
	<20120913235005.3575.46218.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au,
	linux-crypto@vger.kernel.org, zohar@us.ibm.com,
	dmitry.kasatkin@intel.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120913235005.3575.46218.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 14 Sep 2012 00:50:05 +0100
David Howells <dhowells@redhat.com> wrote:

> Add an ASN.1 BER/DER/CER decoder.  This uses the bytecode from the ASN.1
> compiler in the previous patch to inform it as to what to expect to find in the
> encoded byte stream.  The output from the compiler also tells it what functions
> to call on what tags, thus allowing the caller to retrieve information.

Why do this in the kernel.That appears to be completely insane. Can you
prove it runs in a short bounded time for all inputs, has it been fuzz
tested extensively ?

This kind of crap belongs in user space. Parse it in userspace, pass same
structures and objects to the kernel.

Alan
