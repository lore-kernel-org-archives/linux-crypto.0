From: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] Bluetooth: convert smp module to crypto kpp API
Date: Thu, 5 May 2016 08:51:00 -0700
Message-ID: <0CBA8F3F-333C-4E22-B1B9-6FC8734513A7@holtmann.org>
References: <1462440166-94042-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	"Gustavo F. Padovan" <gustavo-THi1TnShQwVAfugRpC6u6w@public.gmane.org>,
	linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Johan Hedberg <johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Salvatore Benedetto <salvatore.benedetto-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462440166-94042-1-git-send-email-salvatore.benedetto-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Salvatore,

> This patch has *not* been tested as I don't have the hardware.
> It's purpose is to show how to use the kpp API.
> 
> Based on https://patchwork.kernel.org/patch/9022371/

actually you should be able to verify this without hardware. The BlueZ userspace package contains tools/mgmt-tester and tools/smp-tester which should both exercise most of the Bluetooth Security Manager (SMP) pieces.

Regards

Marcel
