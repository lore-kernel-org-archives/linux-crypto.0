From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] modsign: don't use bashism in sh scripts.
Date: Tue, 02 Oct 2012 11:54:51 +0930
Message-ID: <87a9w54nm4.fsf@rustcorp.com.au>
References: <87obkq3czk.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk> <27405.1348819833@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <27405.1348819833@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> -    source ./.config
>> +    . ./.config
>
> Does that make a difference?

It does on Ubuntu, where /bin/sh => dash.  "source" is a bashism.

Cheers,
Rusty.
