From: "Hoban, Adrian" <adrian.hoban@intel.com>
Subject: [PATCH 0/3] Optimized RFC4106 AES-GCM implementation using Intel
 New Instructions
Date: Fri, 10 Sep 2010 18:37:02 +0100
Message-ID: <CFBC532374C38D45810FA00BC2D2C2040120CA815B@irsmsx502.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

This set of patches adds an optimized RFC4106 AES-GCM implementation for 64-bit kernels and 128-bit AES keys. It supports processors based on the Intel(r) microarchitecture codename Westmere, such as the Intel(r) Xeon(r) 5600 processor family.

The code leverages the crypto AEAD interface type to facilitate a combined AES & GCM operation to be implemented in a unified block of assembly code. The assembly code leverages Intel(r) AES New Instructions and the carry-less multiple PCLMULQDQ instruction which were introduced on the Intel(r) microarchitecture codename Westmere.

The first patch is an update to the cryptd framework to add support for the AEAD interface type.
The second patch is the RFC4106 AES-GCM Crypto Driver & Assembly Code. 
The third patch is an update to crypto self-test code to extend AES-GCM tests.

For more information on the patches, the assembly code design, and on some performance results please reference these papers:
Using Intel(r) AES New Instructions and PCLMULQDQ to Significantly Improve IPSec Performance on Linux: http://download.intel.com/design/intarch/papers/324238.pdf
Optimized Galois-Counter-Mode Implementation on Intel(r) Architecture Processors: http://download.intel.com/design/intarch/PAPERS/324194.pdf

Regards,
Adrian Hoban
--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.
