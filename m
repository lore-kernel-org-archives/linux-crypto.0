From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
Date: Wed, 25 Sep 2013 22:04:33 +0100
Message-ID: <29408.1380143073@warthog.procyon.org.uk>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee,                          Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <opensuse-kernel+bounces-5131-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1379206621-18639-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
List-Id: linux-crypto.vger.kernel.org


I have pushed some keyrings patches that will likely affect this to:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-devel

I intend to ask James to pull these into his next branch.  If he's happy to do
so, I can look at pulling at least your asymmetric keys patch on top of them.

It'd be helpful if you could see if you need to make any updates.

David
