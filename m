From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate
 snapshot
Date: Sun, 1 Sep 2013 17:46:37 +0100
Message-ID: <20130901164637.GA2409@srcf.ucam.org>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <87eh9dzg00.fsf@mid.deneb.enyo.de>
 <1377734505.19568.39.camel@linux-s257.site>
 <87r4d8vn71.fsf@mid.deneb.enyo.de>
 <20130901160429.GA1375@srcf.ucam.org>
 <87vc2ksdfa.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87vc2ksdfa.fsf-ZqZwdwZz9NfTBotR3TxKnbNAH6kLmebB@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Sep 01, 2013 at 06:40:41PM +0200, Florian Weimer wrote:
> * Matthew Garrett:
> 
> > On Sun, Sep 01, 2013 at 12:41:22PM +0200, Florian Weimer wrote:
> >
> >> But if you don't generate fresh keys on every boot, the persistent
> >> keys are mor exposed to other UEFI applications.  Correct me if I'm
> >> wrong, but I don't think UEFI variables are segregated between
> >> different UEFI applications, so if anyone gets a generic UEFI variable
> >> dumper (or setter) signed by the trusted key, this cryptographic
> >> validation of hibernate snapshots is bypassable.
> >
> > If anyone can execute arbitrary code in your UEFI environment then 
> > you've already lost.
> 
> This is not about arbitrary code execution.  The problematic
> applications which conflict with this proposed functionality are not
> necessarily malicious by themselves and even potentially useful.
 
A signed application that permits the modification of arbitrary boot 
services variables *is* malicious. No implementation is designed to be 
safe in that scenario. Why bother with modifying encryption keys when 
you can just modify MOK instead?

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
