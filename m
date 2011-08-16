From: James Morris <jmorris@namei.org>
Subject: Re: [RFC v1.1 3/5] evm: digital signature support
Date: Tue, 16 Aug 2011 11:03:58 +1000 (EST)
Message-ID: <alpine.LRH.2.00.1108161103020.7706@tundra.namei.org>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com> <d6ca3779df5a812a1b838b0a707a994a341846ed.1313082284.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <d6ca3779df5a812a1b838b0a707a994a341846ed.1313082284.git.dmitry.kasatkin@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 11 Aug 2011, Dmitry Kasatkin wrote:

> From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> 
> When building an image, which has to be flashed to different devices,
> an HMAC cannot be used to sign file metadata, as the HMAC key is different
> on every device. File metadata can be protected using digital signature.
> This patch enables RSA signature based integrity verification.

This description (also the kconfig text) is not very clear.  Perhaps start 
with what the feature does rather than what the lack of it doesn't.



-- 
James Morris
<jmorris@namei.org>
