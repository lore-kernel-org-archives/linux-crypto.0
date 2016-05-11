From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] lib: asn1_decoder - add MODULE_LICENSE("GPL")
Date: Wed, 11 May 2016 14:53:57 +0100
Message-ID: <1963.1462974837@warthog.procyon.org.uk>
References: <1461941288-10356-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461941288-10356-1-git-send-email-tudor-dan.ambarus@nxp.com>
Content-ID: <1962.1462974837.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Tudor Ambarus <tudor-dan.ambarus@nxp.com> wrote:

> A kernel taint results when loading the rsa_generic module:
> 
> root@(none):~# modprobe rsa_generic
> asn1_decoder: module license 'unspecified' taints kernel.
> Disabling lock debugging due to kernel taint
> 
> "Tainting" of the kernel is (usually) a way of indicating that
> a proprietary module has been inserted, which is not the case here.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Applied.
