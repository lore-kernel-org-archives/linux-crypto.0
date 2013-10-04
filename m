From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 0/3] ARM: NEON based fast(er) AES in CBC/CTR/XTS
	modes
Date: Fri, 4 Oct 2013 19:23:53 +0100
Message-ID: <20131004182353.GQ12758@n2100.arm.linux.org.uk>
References: <1380837566-18242-1-git-send-email-ard.biesheuvel@linaro.org> <20131004174853.GY24303@mudshark.cambridge.arm.com> <CAKv+Gu8RdiGw2+o-1ybGTx4fxaGnDQP7duhcFaLuxDphADjMaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Will Deacon <will.deacon@arm.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"patches@linaro.org" <patches@linaro.org>,
	"nico@linaro.org" <nico@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40497 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3JDS3a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Oct 2013 14:29:30 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8RdiGw2+o-1ybGTx4fxaGnDQP7duhcFaLuxDphADjMaQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 04, 2013 at 08:04:50PM +0200, Ard Biesheuvel wrote:
> First of all, please note that the whole point of working so closely
> with the OpenSSL maintainer on this is that the version I am
> presenting here is the verbatim output of the Perl script that lives
> in the OpenSSL tree. So just shipped, not shipped and hacked.
> 
> Personally, I would much prefer merging the .pl file as well, I just
> thought (and I did poll some people informally) that this is not
> something most people are happy about. If I am wrong about this, than
> I am quite happy to respin so the .S is generated on the fly.

While it is desirable to keep the dependencies on external tools to a
minimum, as perl is already on the list of required dependencies, there
is no problem with including a script.

Also, remember that the GPL says:

"The source code for a work means the preferred form of the work for
making modifications to it."

So here's the question: is the assembly code the perferred form to make
modifications?  From what you're saying above, the answer to that seems
to be no.  Now, I'm not going to throw toys out of the pram and say
that this is a hard requirement, but just take a moment to think about
how we treat vendors who don't do this, instead supplying "non-preferred"
forms of source code, and think about whether there's double standards
here.

Now, while I can imagine that people have an ideological objection to
perl (using comments like "write only code" etc) that's not a good
enough excuse to avoid including the perferred form for future
modification.

Now, we have mechanisms in the kernel build where we can include a
prepared source which can be used to lessen the burden on the toolset
required to build the kernel.  So, including both the perl script and
the pre-generated assembly is entirely acceptable.  This tends to
nullify the excuse that "we don't want to add additional tool burden
to kbuild" argument.

So, what I'd strongly recommend is that we add both the pre-generated
assembly with a _shipped suffix, the perl script, and include a rule
like this:

quiet_cmd_perl = PERL    $@
      cmd_perl = perl $< > $@

$(src)/blahblah.S_shipped: $(src)/myperlscript
	$(call cmd,perl)

and that should end up running "myperlscript" whenever it has a date
stamp newer than the _shipped file, or if that file is missing.
