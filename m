From: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Thu, 15 Feb 2007 22:31:52 +0100 (CET)
Message-ID: <1715.81.207.0.53.1171575112.squirrel@secure.samage.net>
References: <Pine.LNX.4.64.0702141121030.20368@woody.linux-foundation.org>
    <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
    <7291.1171482057@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, davej@redhat.com,
	arjan@infradead.org, linux-crypto@vger.kernel.org
To: "David Howells" <dhowells@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161399AbXBOVcF@vger.kernel.org>
In-Reply-To: <7291.1171482057@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

On Wed, February 14, 2007 20:40, David Howells wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> >  (1) A cut-down MPI library derived from GPG with error handling added.
>>
>> Do we really need to add this?
>
> I presume you mean the MPI library specifically?  If so, then yes.  It's
> necessary to do DSA signature verification (or RSA for that matter).
>
>> Wouldn't it be much nicer to just teach people to use one of the existing
>> signature things that we need for _other_ cases anyway, and already have
>> merged?
>
> Existing signature things?  I know not of such beasts, nor can I see them
> offhand.

The question is if using DSA/RSA is the right choice for something like this.
I think that the symmetrically encrypted hash output as signature would provide
the same amount of security. The only additional requirement is that the key
can't be read by userspace. But if they can reach the kernel binary, they can
modify it too. Same for the bootloader, where you'd want the key and initial
checking anyway. Else this whole thing could be done in user space as Roman
Zippel said...

The ELF section stuff seems like unnecessary bloat too. Can't you use/extend
modinfo, or kernel symbols?

With the above changes the code should shrink to only a few hundred new lines
of code, instead of thousands, and signature checking will be much faster too.

Greetings,

Indan
