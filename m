From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/2] digsig: remove unnecessary memory allocation and
 copying
Date: Fri, 1 Feb 2013 16:31:25 +1100 (EST)
Message-ID: <alpine.LRH.2.02.1302011631040.9167@tundra.namei.org>
References: <cover.1359538137.git.dmitry.kasatkin@intel.com> <1ed8eac5fb76f096b794a5f7326eb60a3013ce3d.1359538137.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1ed8eac5fb76f096b794a5f7326eb60a3013ce3d.1359538137.git.dmitry.kasatkin@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 30 Jan 2013, Dmitry Kasatkin wrote:

> In existing use case, copying of the decoded data is unnecessary in
> pkcs_1_v1_5_decode_emsa. It is just enough to get pointer to the message.
> Removing copying and extra buffer allocation.

Applied.

-- 
James Morris
<jmorris@namei.org>
