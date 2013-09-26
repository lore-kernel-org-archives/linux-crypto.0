From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Wed, 25 Sep 2013 19:32:51 -0700
Message-ID: <1380162771.18835.47.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
	 <1380147414.18835.36.camel@dabdike.int.hansenpartnership.com>
	 <20130926002730.GA26857@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org,
	"Rafael J.  Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"David  S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Return-path: <opensuse-kernel+bounces-5139-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20130926002730.GA26857-tWAi6jLit6GreWDznjuHag@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
List-Id: linux-crypto.vger.kernel.org

On Thu, 2013-09-26 at 02:27 +0200, Pavel Machek wrote:
> On Wed 2013-09-25 15:16:54, James Bottomley wrote:
> > On Wed, 2013-09-25 at 17:25 -0400, Alan Stern wrote:
> > > On Wed, 25 Sep 2013, David Howells wrote:
> > > 
> > > > I have pushed some keyrings patches that will likely affect this to:
> > > > 
> > > > 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-devel
> > > > 
> > > > I intend to ask James to pull these into his next branch.  If he's happy to do
> > > > so, I can look at pulling at least your asymmetric keys patch on top of them.
> > > 
> > > This suggests a point that I raised at the Linux Plumbers conference:
> > > 
> > > Why are asymmetric keys used for verifying the hibernation image?  It
> > > seems that a symmetric key would work just as well.  And it would be a
> > > lot quicker to generate, because it wouldn't need any high-precision
> > > integer computations.
> > 
> > The reason is the desire to validate that the previous kernel created
> > something which it passed on to the current kernel (in this case, the
> > hibernation image) untampered with.  To do that, something must be
> > passed to the prior kernel that can be validated but *not* recreated by
> > the current kernel.
> 
> I don't get this. Why is it important that current kernel can't
> recreate the signature?

The thread model is an attack on the saved information (i.e. the suspend
image) between it being saved by the old kernel and used by the new one.
The important point isn't that the new kernel doesn't have access to
K_{N-1} it's that no-one does: the key is destroyed as soon as the old
kernel terminates however the verification public part P_{N-1} survives.

James

> Current kernel is not considered malicious (if it were, you have worse
> problems).
> 
> 								Pavel
> 
> PS: And yes, it would be nice to have
> Documentation/power/swsusp-uefi.txt (or something) explaining the
> design.
> 
