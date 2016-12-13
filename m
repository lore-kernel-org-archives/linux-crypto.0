From: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Subject: RE: [PATCH] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Tue, 13 Dec 2016 12:20:08 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DB023CA99@AcuExch.aculab.com>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
 <e958f214e8885968be8045ffde813ac339b81178.1481575835.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
To: 'Andy Lutomirski' <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        "keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e958f214e8885968be8045ffde813ac339b81178.1481575835.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Andy Lutomirski
> Sent: 12 December 2016 20:53
> The driver put a constant buffer of all zeros on the stack and
> pointed a scatterlist entry at it in two places.  This doesn't work
> with virtual stacks.  Use a static 16-byte buffer of zeros instead.
...

I didn't think you could dma from static data either.

	David

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
