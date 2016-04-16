From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH] KEYS: Provide keyctls to do public key operations
Date: Sat, 16 Apr 2016 12:33:27 +0100
Message-ID: <17643.1460806407@warthog.procyon.org.uk>
References: <alpine.OSX.2.20.1604151411220.7434@gregoryb-fedora.amr.corp.intel.com> <18908.1460671231@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, pjones@redhat.com, tadeusz.struk@intel.com,
	marcel@holtmann.org, dwmw2@infradead.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbcDPLdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 16 Apr 2016 07:33:31 -0400
In-Reply-To: <alpine.OSX.2.20.1604151411220.7434@gregoryb-fedora.amr.corp.intel.com>
Content-ID: <17642.1460806407.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:

> > The interface for the active ops is a bit clunky as the syscall interface
> > doesn't provide sufficient argument space to pass everything I need to
> > specify.  Some basic integer arguments are specified in a struct and more
> > complex options through a string of key=val pairs - just so I don't have to
> > deal with the compat code for dealing with a struct containing pointers
> > (but I can change to that if it's preferable).
>
> It sounds like the struct would still have pointers to strings that would
> need parsing,

It doesn't:

	struct keyctl_pkey_params {
		__s32		key_id;
		__s32		password_id;
		__u32		data_len;
		__u32		enc_len;
		__u32		__spare[4];
	};

because I have sufficient syscall arguments to pass four pointers - the struct
above, one info string and two buffer pointers.

> so I'm not sure it's that much overhead to handle the short
> strings of key=val pairs. But I'll agree that it feels clunky.

... fixes applied ...

> > +	info->supported_ops = KEYCTL_SUPPORTS_VERIFY;
> 
> Did you intend to include encrypt/decrypt/sign here?

When they're implemented there.

David
