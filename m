From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/2] digsig: make crypto builtin if digsig selected as builtin
Date: Thu, 17 Jul 2014 20:56:50 +0100
Message-ID: <13187.1405627010@warthog.procyon.org.uk>
References: <7afa0a5a9343ddb354478536bd9dc670057fbebe.1405094060.git.d.kasatkin@samsung.com> <cover.1405094060.git.d.kasatkin@samsung.com> <cover.1405094060.git.d.kasatkin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmitry.kasatkin@gmail.com
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <7afa0a5a9343ddb354478536bd9dc670057fbebe.1405094060.git.d.kasatkin@samsung.com>
Content-ID: <13186.1405627010.1@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> When SIGNATURE=y but depends on CRYPTO=m, it selects MPILIB as module
> producing build break. This patch makes digsig to select crypto for
> correcting dependency.

I'll apply this one.

David
